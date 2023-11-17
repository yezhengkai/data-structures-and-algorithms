#!/usr/bin/env bash


julia --project=julia --startup-file=no  -e 'using Pkg; Pkg.test()'