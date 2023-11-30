#!/usr/bin/env bash

function run_julia_tests(){
  julia --project=julia --startup-file=no  -e 'using Pkg; Pkg.test()'
}

function run_python_tests(){
  pushd python || exit
  poetry run pytest -v
  popd || exit
}

function run_rust_tests(){
  pushd rust || exit
  cargo nextest run -v
  popd || exit
}

function run_all_tests() {
  run_julia_tests
  run_python_tests
  run_rust_tests
}

# Run tests
for language in "$@"
do
  if [ "${language}" == "jl" ] || [ "${language}" == "julia" ]; then
    echo "Run julia tests"
    run_julia_tests
  elif [ "${language}" == "py" ] || [ "${language}" == "python" ]; then
    echo "Run python tests"
    run_python_tests
  elif [ "${language}" == "rs" ] || [ "${language}" == "rust" ]; then
    echo "Run rust tests"
    run_rust_tests
  elif [ "${language}" == "all" ]; then
    echo "Run tests on all implemented code"
    run_all_tests
  else
    echo "Arguments support \`jl|julia\`, \`py|python\`, \`rs|rust\` and \`all\`."
  fi
done


