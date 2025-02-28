#!/bin/zsh

# If deployed not locally, use this:
# . ./.env
# Otherwise, use this:
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

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
CONTRACT_ADDRESS="0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
TOKEN_CONTRACT_ADDRESS="0x5FbDB2315678afecb367f032d93F642f64180aa3"
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