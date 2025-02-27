#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
forge script script/DeployAnywhere.s.sol:Deploy --rpc-url "https://sepolia.unichain.org" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -vvvv

./push_artifacts.sh "DeployAnywhere.s.sol/1301"

# cd web
# npm run build