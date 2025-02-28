from web3 import Web3
import time

# Replace these values with your own
private_key = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
rpc_url = "http://127.0.0.1:8545"
contract_address = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
new_number = 42  # The new number you want to set

# Connect to the Ethereum node
web3 = Web3(Web3.HTTPProvider(rpc_url))

# Ensure connection is successful
if not web3.is_connected():
    raise Exception("Failed to connect to the Ethereum node")

# Verify the contract is deployed at the specified address
code = web3.eth.get_code(contract_address)
print(f"Contract bytecode at address {contract_address}: {code.hex()}")
if code == b'0x':
    raise Exception(f"No contract deployed at address {contract_address}")

# Define the contract ABI
contract_abi = [
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "newNumber",
                "type": "uint256"
            }
        ],
        "name": "setNumber",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "newNumber",
                "type": "uint256"
            }
        ],
        "name": "getNumber",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "stateMutability": "view",
        "type": "function",
        "name": "number",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ]
    },
    {
        "inputs": [],
        "name": "increment",
        "outputs": [],
        'stateMutability': 'nonpayable',
        'type': 'function'
    }
]

# Create the contract instance
contract = web3.eth.contract(address=contract_address, abi=contract_abi)

# Get the account from the private key
account = web3.eth.account.from_key(private_key)

# Build the transaction
transaction = contract.functions.setNumber(new_number).build_transaction({
    'from': account.address,
    'nonce': web3.eth.get_transaction_count(account.address),
    'gas': 2000000,
    'gasPrice': web3.to_wei('50', 'gwei')
})

# Sign the transaction
signed_txn = web3.eth.account.sign_transaction(transaction, private_key=private_key)

# Send the transaction
tx_hash = web3.eth.send_raw_transaction(signed_txn.raw_transaction)

# Wait for the transaction to be mined
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
print(f"Transaction receipt: {tx_receipt}")

print(f"Transaction successful with hash: {tx_hash.hex()}")

# Add a delay to ensure the state is updated
time.sleep(3)

# Call the number() function and print the result
try:
#    current_number = contract.functions.number().transact()
    current_number = contract.functions.number().call()
#    current_number = contract.functions.getNumber(0).call()
    print(f"The current number is: {current_number}")
except Exception as e:
    print(f"An error occurred: {e}")