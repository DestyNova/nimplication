import strformat,tables,unittest
import nimplication as nm

test "parse all pos":
  let data = nm.load("tests/cnf/buffalo_all_pos_sat.cnf")
  echo fmt"data: {data}"
  check data.len == 5
  check data == @[@[1, 6, 7, 8], @[2], @[3, 5], @[4], @[9]]

test "parse negations":
  let data = nm.load("tests/cnf/buffalo_one_conflict_sat.cnf")
  echo fmt"data: {data}"
  check data.len == 6
  check data == @[@[1, 6, 7, 8], @[2], @[3, 5], @[4], @[9], @[-2, -3]]

test "sat all pos":
  let data = nm.load("tests/cnf/buffalo_all_pos_sat.cnf")
  check nm.sat(data).len > 0

test "sat ex1":
  let data = nm.load("tests/cnf/buffalo_one_conflict_sat.cnf")
  check nm.sat(data).len > 0

test "unsat ex2":
  let data = nm.load("tests/cnf/buffalo_unsat.cnf")
  check nm.sat(data).len == 0

test "sat lp":
  let data = nm.load("tests/cnf/lp.cnf")
  check nm.sat(data).len > 0

test "sat tanker":
  let data = nm.load("tests/cnf/tanker.cnf")
  check nm.sat(data).len > 0

test "sat nqueens8":
  let data = nm.load("tests/cnf/nqueens8.cnf")
  check nm.sat(data,true).len > 0

# test "sat nqueens12": # slow
#   let data = nm.load("tests/cnf/nqueens12.cnf")
#   check nm.sat(data).len > 0
#
# test "sat nqueens16": # very slow
#   let data = nm.load("tests/cnf/nqueens12.cnf")
#   check nm.sat(data).len > 0
#
# test "sat nqueens20": # exceedingly slow
#   let data = nm.load("tests/cnf/nqueens20.cnf")
#   check nm.sat(data).len > 0
