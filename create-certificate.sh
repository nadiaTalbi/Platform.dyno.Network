source scriptUtils.sh
export PATH=${PWD}/../bin:$PATH


certificatesForDyno() {
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ./consortium/crypto-config/peerOrganizations/dyno
    export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/peerOrganizations/dyno

    fabric-ca-client enroll -u https://admin:adminpw@localhost:1010 --caname ca.dyno --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    echo 'NodeOUs:
    Enable: true
    ClientOUIndentifier:
        certificate: cacerts/localhost-1010-ca-dyno.pem
        OrganizationalUnitIdentifier: client
    PeerOUIndentifier:
        certificate: cacerts/localhost-1010-ca-dyno.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIndentifier:
        certificate: cacerts/localhost-1010-ca-dyno.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIndentifier:
        certificate: cacerts/localhost-1010-ca-dyno.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/config.yaml

    
    echo
    echo "Register peer0"
    echo 
    fabric-ca-client register --caname ca.dyno --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    echo
    echo "Register peer1"
    echo 
    fabric-ca-client register --caname ca.dyno --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    echo
    echo "Register user"
    echo 
    fabric-ca-client register --caname ca.dyno --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    echo
    echo "Register the org admin"
    echo 
    fabric-ca-client register --caname ca.dyno --id.name dynoadmin --id.secret dynoadminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem


    ######################################################################
    # Peer 
    # Peer 0
    mkdir -p consortium/crypto-config/peerOrganizations/dyno/peers

    mkdir -p consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno

    echo 
    echo "Generate the peer0 msp"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1010 --caname ca.dyno -M ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/msp --csr.hosts peer0.dyno --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/config.yaml  ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/msp/config.yaml


    echo 
    echo "Generate the peer0-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1010 --caname ca.dyno -M ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls --enrollment.profile tls --csr.hosts peer0.dyno --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/ca.crt
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/server.crt
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/server.key

    mkdir ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/tlscacerts
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/tlscacerts/ca.crt

    mkdir ${PWD}/consortium/crypto-config/peerOrganizations/dyno/tlsca
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/tlsca/tlsca.dyno-cert.pem

    mkdir ${PWD}/consortium/crypto-config/peerOrganizations/dyno/ca
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer0.dyno/msp/cacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/ca/ca.dyno-cert.pem
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/ca

    # Peer 1
    mkdir -p consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno

    echo 
    echo "Generate the peer1 msp"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1010 --caname ca.dyno -M ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/msp --csr.hosts peer1.dyno --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/config.yaml  ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/msp/config.yaml

    echo 
    echo "Generate the peer1-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1010 --caname ca.dyno -M ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls --enrollment.profile tls --csr.hosts peer1.dyno --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls/ca.crt
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls/server.crt
    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/dyno/peers/peer1.dyno/tls/server.key


    ############################################################################
    # Users
    # User1
    mkdir -p consortium/crypto-config/peerOrganizations/dyno/users
    mkdir -p consortium/crypto-config/peerOrganizations/dyno/users/User1

    echo 
    echo "Generate the user msp"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:1010 --caname ca.dyno -M ${PWD}/consortium/crypto-config/peerOrganizations/dyno/users/User1/msp --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    # Admin
    mkdir -p consortium/crypto-config/peerOrganizations/dyno/users/Admin@dyno

    echo 
    echo "Generate the admin msp"
    echo
    fabric-ca-client enroll -u https://dynoadmin:dynoadminpw@localhost:1010 --caname ca.dyno -M ${PWD}/consortium/crypto-config/peerOrganizations/dyno/users/User1/msp --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/peerOrganizations/dyno/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/dyno/users/Admin@dyno/msp/config.yaml

}


certificatesForOrderer() {
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ./consortium/crypto-config/ordererOrganizations/example.com
    export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/ordererOrganizations/example.com

    fabric-ca-client enroll -u https://admin:adminpw@localhost:1030 --caname ca-orderer --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

    echo 'NodeOUs:
    Enable: true
    ClientOUIndentifier:
        certificate: cacerts/localhost-1030-ca-orderer.pem
        OrganizationalUnitIdentifier: client
    PeerOUIndentifier:
        certificate: cacerts/localhost-1030-ca-orderer.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIndentifier:
        certificate: cacerts/localhost-1030-ca-orderer.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIndentifier:
        certificate: cacerts/localhost-1030-ca-orderer.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml

    
    echo
    echo "Register orderer"
    echo 
    fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

    echo
    echo "Register the orderer admin"
    echo 
    fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

    mkdir -p ./consortium/crypto-config/ordererOrganizations/example.com/orderers
    mkdir -p ./consortium/crypto-config/ordererOrganizations/example.com/orderers/example.com



    ######################################################################
    # Orderer
    mkdir -p ./consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com

    echo 
    echo "Generate the orderer msp"
    echo
    fabric-ca-client enroll -u https://orderer:ordererpw@localhost:1030 --caname ca-orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/msp -csr.hosts orderer.dyno --csr.hosts localhost  --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml  ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

    echo 
    echo "Generate the orderer-tls certificates"
    echo
    fabric-ca-client enroll -u https://orderer:ordererpw@localhost:1030 --caname ca-orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/msp --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/ca.crt
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/signcerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/server.crt
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/keystore/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/server.key

    mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/msp/tlscacerts
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/tlscacerts
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.exapmle.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/tlsca/tlsca.dyno-cert.pem

    mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/ca
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/keystore/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/ca

    ##############################################################################

    mkdir -p consortium/crypto-config/ordererOrganizations/example.com/users
    mkdir -p consortium/crypto-config/ordererOrganizations/example.com/users/Admin@example.com

    echo
    echo "Generate the admin msp"
    echo

    fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:1030 --caname ca-orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/consortium/fabric-ca/dyno/tls-cert.pem

    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}


#certificate authorities compose file
#COMPOSE_FILE_CA=base/docker-compose-ca.yaml

#IMAGE_TAG= docker-compose -f $COMPOSE_FILE_CA up -d 2>&1

#sleep 6
#docker ps

infoln "Create Dyno Indentities"
certificatesForDyno

#infoln "Create Orderer Indentities"
#certificatesForOrderer

#infoln "Generate CCP file for all organizations"
#consortium/ccp-generate.sh



