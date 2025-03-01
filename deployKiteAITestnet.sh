#!/bin/sh

set -e

# To load the variables in the .env file
. ./.env

# To deploy and verify our contract
#forge script script/DeployAnywhere.s.sol:Deploy --rpc-url "https://api.avax.network/ext/bc/C/rpc" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -v
forge script script/DeployAnywhere.s.sol:Deploy --rpc-url "https://rpc-testnet.gokite.ai" --sender $SENDER --private-key $PRIVATE_KEY --broadcast -v

./push_artifacts.sh "DeployAnywhere.s.sol/2368"

# cd web
# npm run build