#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
forge script script/DeployAnywhere.s.sol:Deploy --slow --rpc-url "https://testnet.evm.nodes.onflow.org" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

./push_artifacts.sh "DeployAnywhere.s.sol/545"

# cd web
# npm run build