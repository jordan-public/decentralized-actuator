#!/bin/zsh

set -e

# Run anvil.sh in another shell before running this

# To deploy and verify our contract
forge script script/DeployAnywhere.s.sol:Deploy --rpc-url "http://127.0.0.1:8545/" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -v

./push_artifacts.sh "DeployAnywhere.s.sol/31337"

# cd web
# npm run build