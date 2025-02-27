#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
forge script script/DeployAnywhere.s.sol:Deploy --rpc-url $ICP_RPC --sender $SENDER --private-key $PRIVATE_KEY --broadcast -v

./push_artifacts.sh "DeployAnywhere.s.sol/142857"

# cd web
# npm run build