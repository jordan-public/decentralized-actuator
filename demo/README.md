# Demo Video and Deployment Addresses

## Demo Video

The demo video can be found [here](./Do-racle.mov) and on [YouTube](https://youtu.be/Ut5rSXBVCHc).

## How to run

To install and run the DoRacle protocol, clone this repo and in it:

- Copy the .env files:
```
cp .env.sample .env
cp langchain-api/.env.sample langchain-api/.env
```
 and fill in the appropriate private data in them.

 - If running locally start Anvil in one ZSH terminal and deploy the contracts locally in another:
 ```
 ./Anvil.sh
 ```

 ```
 ./deployAnvil.sh
```

- In a third terminal install and run the front end:
```
cd web
pnpm install
pnpm dev
```
and visit the URL ```http://localhost:3000``` with a browser with MetaMask wallet extension installed.

- Run the sample AI Agent which uses our LangChain Tool and OpenAI in a fourth terminal:
```
cd langchain-api
./testDoRacleAgent.sh
```

The AI Agent should create Do-racle Actions which can be taken, executed and otherwise managed in the browser opened in the step above.

## Contract deployment addresses

### Hedera:

DoRacle: 0xE28C059f74e0044C01bD06e9B0A2642D5d1717e6

DoRacleToken: 0x0888091227379c6e5719859F7A39024edA454E20

### Flow Testnet:

DoRacle: 0x9564a8891EC6099abBb51Bee2D2627510177a894

DoRacleToken: 0x20A215E723Ce785fa9b7c135c762D848C496072B

### Unichain Sepolia:

DoRacle: 0x87876361e93346ac59acE9Da86ed1Cee6Bf0E5ed

DoRacleToken: 0x3e2cb428EcDfC4A90F300855eC4A64f411301ddE

### Base Sepolia:

DoRacle: 0x38288e03211FD049d9A10eC72333d121EBDa8178

DoRacleToken: 0xD457436EBD456774E44F1Fa468D1D7423cFD9ddE

### Zircuit Testnet:

DoRacle: 0x87876361e93346ac59acE9Da86ed1Cee6Bf0E5ed

DoRacleToken: 0x3e2cb428EcDfC4A90F300855eC4A64f411301ddE

