# Nimplication

A toy SAT solver implementing the [DPLL algorithm](https://en.wikipedia.org/wiki/DPLL_algorithm). It can solve a few very easy problems (see the files in `tests/cnf`) but quickly gets bogged down -- for example, n-queens is solved in less than a second for n=8, around 5 seconds for n=12, then quickly becomes intractable. This was made solely for fun and educational value.

## Future possibilities

* Try [conflict-driven clause learning](https://en.wikipedia.org/wiki/Conflict-driven_clause_learning) instead of DPLL
* Multithread it somehow (e.g. handle the two DFS paths in separate threads, up to some pool limit)
* Genetic algorithm for exploring better-looking parts of the search space
    * (but how can we avoid getting stuck in local optima?)
