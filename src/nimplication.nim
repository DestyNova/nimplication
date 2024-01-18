import math,os,sequtils,strutils,strformat,sugar,tables

type Clause* = seq[int]

proc load*(path: string): seq[Clause] =
  var
    clauses: seq[Clause]
    c: Clause
  for s in path.lines:
    case (s & "*")[0]:
      of 'c','p','*':
        continue
      else:
        let terms = s.splitWhitespace.map(parseInt)
        c.add(terms)
        if terms[^1] == 0:
          clauses.add(c[0..^2])
          c = newSeq[int]()
  clauses

proc sat*(clauses: seq[Clause], debug = false): Table[int,int] =
  var maxSat = 0
  proc satRec(clauses: seq[Clause], partial = initTable[int,int]()): Table[int,int] =
    var
      vs = partial
      ts = initTable[int,int]()

    # unit propagation when exactly 1 unassigned literal and zero or more unsat literals
    for c in clauses:
      var unassigned = 0
      for t in c:
        let v = vs.getOrDefault(t.abs)
        if v == 0 and unassigned != 0:
          # found two unknowns; can't propagate
          unassigned = 0
          break
        elif v == 0:
          unassigned = t
        elif v == t.sgn:
          # clause is already satisfied; can't propagate
          unassigned = 0
          break
      if unassigned != 0:
        vs[unassigned.abs] = unassigned.sgn

    # pure symbol elimination
    for c in clauses:
      for t in c:
        if t.abs notin vs: vs[t.abs] = 0
        ts[t.abs] = if ts.getOrDefault(t.abs, t.sgn) != t.sgn: 0 else: t.sgn
    for t,v in ts:
      if v != 0 and vs[t] != 0 and vs[t] != v:
        raise newException(IOError,"Pure heuristic conflict for {t}:({vs[t]} | {v}), impossible?")
      elif v != 0: vs[t] = v

    # check for early termination
    var
      trueCount = 0
      falseCount = 0
    for c in clauses:
      trueCount += (if c.any(x => vs[x.abs] == x.sgn and vs[x.abs] != 0): 1 else: 0)
      falseCount += (if c.all(x => vs[x.abs] == -x.sgn and vs[x.abs] != 0): 1 else: 0)

    if trueCount > maxSat and debug:
      echo fmt"true count: {trueCount}/{clauses.len}, false count: {falseCount}/{clauses.len}"
      maxSat = trueCount

    let
      allTrue = trueCount == clauses.len
      anyFalse = falseCount > 0
    assert not (allTrue and anyFalse)

    if allTrue: return vs
    elif anyFalse: return
    else:
      for k,v in vs:
        if v == 0:
          vs[k] = 1                 # backtrack with the first free variable set to true
          let r = satRec(clauses, vs)
          if r.len > 0: return r
          vs[k] = -1                # then false
          let r2 = satRec(clauses, vs)
          if r2.len > 0: return r2
          return
    return
  satRec(clauses)

when isMainModule:
  let data = load(paramStr(1))
  echo sat(data, true)
