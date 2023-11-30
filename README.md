# Data Structures and Algorithms
Use different programming languages ​​to implement data structures and algorithms as exercises.

| Language | Test |
|:--------|:------:|
|Python|[![Run python tests](https://github.com/yezhengkai/data-structures-and-algorithms/actions/workflows/run_python_tests.yml/badge.svg)](https://github.com/yezhengkai/data-structures-and-algorithms/actions/workflows/run_python_tests.yml)|
|Rust|[![Run rust tests](https://github.com/yezhengkai/data-structures-and-algorithms/actions/workflows/run_rust_tests.yml/badge.svg)](https://github.com/yezhengkai/data-structures-and-algorithms/actions/workflows/run_rust_tests.yml)|

## Setup
### Julia
1. Install [Julia](https://julialang.org/) programming language.
1. Run `julia --project=.` in `julia` directory to activate project.
1. Run `] instantiate` to install dependencies and current project.

### Python
1. Install [Python](https://www.python.org/) programming language.
1. Install [Poetry](https://python-poetry.org/) package manager.
1. Run `poetry install` in `python` directory to install dependencies and current project.

### Rust
1. Install [Rust](https://www.rust-lang.org/) programming language.
1. Install [Nextest](https://github.com/nextest-rs/nextest) test runner for Rust.

## Test on Local Machine
Run tests with `./runtests.sh LANGUAGE...`.
For example:
```bash
./runtests.sh jl
```
```bash
./runtests.sh jl py
```
```bash
./runtests.sh all
```

## References
- [Hello 算法](https://www.hello-algo.com/)
- [The Algorithms](https://the-algorithms.com/)
- [GitHub: JuliaCollections/DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl)
- [GitHub: mgcth/DataStructuresAlgorithms.jl](https://github.com/mgcth/DataStructuresAlgorithms.jl)
- [GiHub: hesseltuinhof/DataStructures.jl](https://github.com/hesseltuinhof/DataStructures.jl)
- [GitHub: ChrisRackauckas/LinkedLists.jl](https://github.com/ChrisRackauckas/LinkedLists.jl)