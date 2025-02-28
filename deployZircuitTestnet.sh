#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
forge script script/DeployAnywhere.s.sol:Deploy --rpc-url "https://zircuit1-testnet.p2pify.com" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

./push_artifacts.sh "DeployAnywhere.s.sol/48899"

# cd web
# npm run build