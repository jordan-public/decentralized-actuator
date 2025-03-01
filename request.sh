#!/bin/zsh

# If deployed not locally, use this:
. ../.env

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <DESCRIPTION>"
  exit 1
fi

# Assign arguments to variables
# From deployAnvil.sh:
RPC_URL="http://127.0.0.1:8545/"
# from .env: 
# PRIVATE_KEY=$2
# From deployAnvil first contract is always:
CONTRACT_ADDRESS="0xE71C57852392123BbE527A16271D2E6395c66e8b"
TOKEN_CONTRACT_ADDRESS="0xE53F8E8a492e85E87AE553AcFb676cEfF50740A6"
DESCRIPTION=$1
REWARD="100000000000000000000"
GUARANTEE="10000000000000000000"

# Calculate timestamps
EXECUTE_DEADLINE=$(($(date +%s) + 100))
DISPUTE_DEADLINE=$(($(date +%s) + 200))
VOTE_DEADLINE=$(($(date +%s) + 300))

echo EXECUTE_DEADLINE: $EXECUTE_DEADLINE
echo DISPUTE_DEADLINE: $DISPUTE_DEADLINE
echo VOTE_DEADLINE: $VOTE_DEADLINE

# Execute mint on the token contract
cast send --rpc-url $RPC_URL --private-key $PRIVATE_KEY --gas-limit 1000000 $TOKEN_CONTRACT_ADDRESS "mint(uint256)" $REWARD
# Print empty line
echo
# Execute approve on the token contract
cast send --rpc-url $RPC_URL --private-key $PRIVATE_KEY --gas-limit 1000000 $TOKEN_CONTRACT_ADDRESS "approve(address,uint256)" $CONTRACT_ADDRESS $REWARD
# Print empty line
echo
# Execute requestAction
cast send --rpc-url $RPC_URL --private-key $PRIVATE_KEY --gas-limit 1000000 $CONTRACT_ADDRESS "requestAction(string,uint256,uint256,uint256,uint256,uint256)" $DESCRIPTION $REWARD $GUARANTEE $EXECUTE_DEADLINE $DISPUTE_DEADLINE $VOTE_DEADLINE