package main

import (
    "context"
    "crypto/ecdsa"
    "log"
    "math/big"
    "os"

    "github.com/ethereum/go-ethereum/common"
    "github.com/ethereum/go-ethereum/core/types"
    "github.com/ethereum/go-ethereum/crypto"
    "github.com/ethereum/go-ethereum/ethclient"
    "github.com/ethereum/go-ethereum/rpc"
    "github.com/joho/godotenv"
)

const (
    sepoliaEndpoint = "https://testnet.hashio.io/api" // "https://sepolia.infura.io/v3/ddb0c25acabf42389997d77c02ae261d"
)

func singleTest(sepoliaEndpoint, privateKeyName string, chain int64) {
    log.Printf("Running on %v", sepoliaEndpoint)
    err := godotenv.Load()
    if err != nil {
        log.Fatalf("Error loading .env file")
    }

    privateKeyHex := os.Getenv(privateKeyName)
    privateKey, err := crypto.HexToECDSA(privateKeyHex)
    if err != nil {
        log.Fatalf("Invalid private key: %v", err)
    }
    publicKey := privateKey.Public()
    publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)

    if !ok {
        log.Fatalf("Failed to cast public key to ECDSA")
    }

    ethereumClient, err := ethclient.Dial(sepoliaEndpoint)
    if err != nil {
        log.Fatalf("Failed to connect to the Ethereum client: %v", err)
    }
    ethereumClientrpc, err := rpc.Dial(sepoliaEndpoint)
    if err != nil {
        log.Fatalf("Failed to connect to the Ethereum RPC client: %v", err)
    }

    fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
    ctx := context.Background()
    nonce, err := ethereumClient.PendingNonceAt(ctx, fromAddress)
    if err != nil {
        log.Fatalf("Failed to retrieve account nonce: %v", err)
    }

    toAddress := common.HexToAddress("0x5d30Fdae0fDE5656546affd341F16fF617f49D72")
    value := big.NewInt(1000000000000000)
    gasLimit := uint64(21000)
    gasPrice := big.NewInt(1050000000000)
    data := []byte{}
    tx := types.NewTransaction(nonce, toAddress, value, gasLimit, gasPrice, data)
    chainID := big.NewInt(chain)
    signer := types.NewEIP155Signer(chainID)
    signedTx, err := types.SignTx(tx, signer, privateKey)
    if err != nil {
        log.Fatalf("Failed to sign transaction: %v", err)
    }

    rawTxData, err := signedTx.MarshalBinary()
    if err != nil {
        log.Fatalf("Failed to encode transaction: %v", err)
    }
    v, _, _ := signedTx.RawSignatureValues()
    log.Printf("v value before submitting: %v", v)

    var ethereumTxHash string
    err = ethereumClientrpc.Call(&ethereumTxHash, "eth_sendRawTransaction", "0x"+common.Bytes2Hex(rawTxData))
    if err != nil {
        log.Fatalf("Failed to send transaction to Ethereum: %v", err)
    }

    log.Printf("New transaction hash: %v", ethereumTxHash)

    var result map[string]interface{}
    err = ethereumClientrpc.Call(&result, "eth_getTransactionByHash", ethereumTxHash)
    if err != nil {
        log.Fatalf("Failed to get transaction by hash: %v", err)
    }

    v2, ok := new(big.Int).SetString(result["v"].(string)[2:], 16)
    if !ok {
        log.Fatalf("Invalid 'v' value")
    }
    if v.Cmp(v2) != 0 {
        log.Printf("v was changed to %v", v2)
    } else {
        log.Println("v is still ok")
    }
}

func main() {
    singleTest("https://sepolia.infura.io/v3/{API_KEY}", "ETHEREUM_PRIVATE_KEY", 11155111)
    singleTest("https://testnet.hashio.io/api", "OPERATOR_PRIVATE_KEY", 296)

}