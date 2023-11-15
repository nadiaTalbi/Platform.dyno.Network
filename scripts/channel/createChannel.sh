#!/bin/bash
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CORE_PEER_TLS_ENABLED=true

echo "Creating channel..."
peer channel create -o orderer.example.com:7050 /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -c mychannel --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -f ./channel-artifacts/channel.tx
#peer channel create: This is the command to create a new channe
#-o orderer.example.com:7050: Specifies the orderer's address and port.
#--tls $CORE_PEER_TLS_ENABLED: Indicates whether TLS should be used
#--cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem: Specifies the path to the TLS CA certificate file of the orderer. This is used for secure communication.
#-c dynochannel: Specifies the name of the channel to be created.
#-f ./channel-artifacts/channel.tx: Specifies the path to the channel configuration transaction file


echo 
echo "Channel created, joining dyno..."
peer channel join -b genesis.block
#peer channel join: This is the command to make a peer join a channel
#-b dynochannel.block: Specifies the path to the latest channel configuration block file 