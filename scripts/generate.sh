#!/bin/bash

echo "Generating cryto material for peers..."

[ -d channel-artifacts ] || mkdir channel-artifacts #checks if the channel-artifacts exists, if not it will be created.

../bin/cryptogen generate --config=./crypto-config.yaml #This command uses the cryptogen tool to generate cryptographic material for the network based on the configuration specified in crypto-config.yaml

[ -d crypto-config ] || mkdir crypto-config #checks if the crypto-config exists, if not it will be created.

echo "Generating channel artifacts and genesis block..."

#This command uses the configtxgen tool to generate the genesis block for the orderer based on the specified profile (TwoOrgsOrdererGenesis). The generated block is placed in the channel-artifacts directory
../bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

#This command generates the channel configuration transaction for the specified channel ID (dynochannel) using the profile TwoOrgsChannel. The resulting transaction is saved as channel.tx in the channel-artifacts directory
../bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID dynochannel
