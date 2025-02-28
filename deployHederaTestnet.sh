#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
#forge script script/DeployAnywhere.s.sol:Deploy --slow --rpc-url "https://296.rpc.thirdweb.com" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv
forge script script/DeployAnywhere.s.sol:Deploy --slow --rpc-url "https://testnet.hashio.io/api" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

./push_artifacts.sh "DeployAnywhere.s.sol/296"

# cd web
# npm run build