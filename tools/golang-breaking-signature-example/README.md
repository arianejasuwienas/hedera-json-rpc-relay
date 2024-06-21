# Hedera Golang Project Creating a Broken Legacy Transaction on Hedera network
An example on how to create a broken legacy transaction with incorrect v on the Hedera network and comparing it to Ethereum network.

In order to create the broken transaction on our own, we need to follow these steps:
1. **Create and Send a Correct Transaction:** We have to ensure the transaction has a proper v value. If the v value is not correct, it will not be accepted by the hash.io or any other provider. Below are the error responses I’ve received:
   - hashio. response:
        ```json
        {
        "error": {
        "code": -32603,
        "message": "[Request ID: c0fde016-2bfc-47eb-a834-bccf392ca06d] Error invoking RPC: non-canonical legacy v (argument=\"v\", value=\"0x01\", code=INVALID_ARGUMENT, version=6.12.2)"
        },
        "jsonrpc": "2.0",
        "id": 1
        }
        ```
   - infura response:
        ```json
        {
        "jsonrpc": "2.0",
        "id": 0,
        "error": {
        "code": -32602,
        "message": "transaction could not be decoded: could not recover secp256k1 key: invalid signature: not for a valid curve point"
        }
        }
        ```
2. **Retrieve the Transaction Data:** After sending the transaction, we have to retrieve the transaction data from the network. We will observe that the transaction’s signature v is 0 or 1 in Hedera (and only there)...
   This indicates that the correct v value you initially sent is replaced at some stage, not on the client side but on Hedera’s side!

## Requirements
Install go: https://go.dev/doc/install

## Setup

1. Clone this repo to your local machine:

```shell
git clone https://github.com/hashgraph/hedera-json-rpc-relay.git
```

2. Once you've cloned the repository, open your IDE terminal and navigate to the root directory of the project:

```shell
cd hedera-json-rpc-relay/tools/golang-breaking-signature-example
```

3. Run the following command to install all the necessary dependencies:

```shell
go get github.com/ethereum/go-ethereum/ethclient \
       github.com/ethereum/go-ethereum \
       github.com/ethereum/go-ethereum/accounts/abi/bind \
       github.com/ethereum/go-ethereum/crypto \
       github.com/joho/godotenv
go get -t hedera-breaking-signature-example-project
```
4. Copy `.env.example` to `.env`

5. Get your Hedera testnet account hex encoded private key from the [Hedera Developer Portal](https://portal.hedera.com/register) and update the `.env` `OPERATOR_PRIVATE_KEY`

6. Get your Ethereum Sepolia account hex encoded private key eg. from the [Metamask](https://support.metamask.io/getting-started/getting-started-with-metamask/) and update the `.env` `ETHEREUM_PRIVATE_KEY`

7. Get your [Infura api key](https://www.infura.io) and update the `.env` `INFURA_API_KEY`

8. Run the script from the root directory of the project.

```shell
go run .
```
