#!/usr/bin/env bash

# Run tests
for language in "$@"
do
  if [ "${language}" == "jl" ] || [ "${language}" == "julia" ]; then
    echo "Run julia tests"
    julia --project=julia --startup-file=no  -e 'using Pkg; Pkg.test()'
  elif [ "${language}" == "py" ] || [ "${language}" == "python" ]; then
    echo "Run python tests"
    pushd python || exit
    poetry run pytest
    popd || exit
  elif [ "${language}" == "rs" ] || [ "${language}" == "rust" ]; then
    echo "Run rust tests"
    echo "Not implemented"
  elif [ "${language}" == "all" ]; then
    echo "Run tests on all implemented code"
    echo "Not implemented"
  else
    echo "Arguments support \`jl|julia\`, \`py|python\`, \`rs|rust\` and \`all\`."
  fi
done


