# Supply chain & data auditing

This repository containts an Ethereum DApp that demonstrates a Food Chain flow between a Consumer and Cook and Delivery person. The user story is similar to any commonly used supply chain process. A Consumer can place Order to the inventory system stored in the blockchain. A Cook can prepare such order from the inventory system. Additionally a Cook can mark an order as Prepare, and Delivery Person can a select and delivery the order and consumer can mark an order as Received.

The Contract is deployed on rinkeby network.

## Contract Deployed 
### SupplyChain Contract
```
Contract Address: 0x584D222701A9fAd97C93e3227e8e9fD7dECac506
transaction hash: 0x6e0d764540f95adb33cbef50dfa5c018b35c42436f321531f6e760ffcbaf8f7d

```
### ConsumerRole Contract
```
Contract Address: 0x584D222701A9fAd97C93e3227e8e9fD7dECac506
transaction hash: 0x6e0d764540f95adb33cbef50dfa5c018b35c42436f321531f6e760ffcbaf8f7d

```
### KitchenRole Contract
```
Contract Address: 0xcF2A8b115a09C535916EF8F1a567fcDd76016253
transaction hash: 0xa9fffee86c21041fb1cf51c0801782be4276007dc93ac711883afb84754298cc

```

### DeliveryRole Contract
```
Contract Address: 0xb96c8EAAF577b8B41f78658b2dbe591330D54720
transaction hash: 0x259b8d4b8e5d86039bf83160dd19dae71f7efcbe912db9dea90642f02dc1a0d1

```

### DistributorRole Contract
```
Contract Address: 0x682d99EA1739e53eb1758Fc9A6bF6E14063220CF
transaction hash: 0x832236266f42d69d5f898249e51a4e79fc6fafd34137a2b7473293485a17ef81

```

### Migration Contract
```
Contract Address: 0xBf1ee817181a5275F1910C0823591c5b75d30f71
transaction hash: 0x462432177a7959904b997004c4cc4a7eb7d259e389bd33174cc62934d52f99d0

```




## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Please make sure you've already installed ganache-cli, Truffle and enabled MetaMask extension in your browser.


### Installing

A step by step series of examples that tell you have to get a development env running



```
cd project-6
npm install
```

Launch Ganache:

```
ganache-cli -m "spirit supply whale amount human item harsh scare congress discover talent hamster"
```

In a separate terminal window, Compile smart contracts:

```
truffle compile
```


This will create the smart contract artifacts in folder ```build\contracts```.

Migrate smart contracts to the locally running blockchain, ganache-cli:

```
truffle migrate
```

Test smart contracts:

```
truffle test
```

All 6 tests should pass.
 
In a separate terminal window, launch the DApp:

```
npm run dev
```

## Built With

* [Ethereum](https://www.ethereum.org/) - Ethereum is a decentralized platform that runs smart contracts
* [Truffle Framework](http://truffleframework.com/) - Truffle is the most popular development framework for Ethereum with a mission to make your life a whole lot easier.


 
## Acknowledgments

* Solidity
* Ganache-cli
* Truffle
* IPFS
