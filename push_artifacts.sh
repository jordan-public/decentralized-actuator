#!/bin/sh

# Usage: ./push_artifacts.sh <chain_id>

rm web/src/artifacts/*.json

# Ignore errors
for dirname in out/*.sol; do
    cat $dirname/$(basename "$dirname" .sol).json | jq '{abi: .abi}' > web/src/artifacts/$(basename "$dirname" .sol).json
done

cat broadcast/$1/run-latest.json out/DoRacle.sol/DoRacle.json | \
jq -s \
    'add | 
    { chain: .chain} * (.transactions[] |
    { transactionType, contractName, contractAddress } |
    select(.transactionType == "CREATE" and .contractName == "DoRacle") |
    {contractName, contractAddress}) * {abi: .abi}' > web/src/artifacts/DoRacle.json
