#!/bin/zsh
. ./.env

# To deploy and verify our contract
# forge test --rpc-url "http://127.0.0.1:8545/" -vvv --debug "testBad()"
forge test -vvv --debug "testBad()"
