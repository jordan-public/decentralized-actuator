#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
forge script script/DeployAnywhere.s.sol:Deploy --rpc-url $BASE_SEPOLIA_RPC --sender $SENDER --private-key $PRIVATE_KEY --broadcast -v

./push_artifacts.sh "DeployAnywhere.s.sol/84532"

# cd web
# npm run build