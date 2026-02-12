workspace "Quantum Blockchain" "A general-purpose blockchain system in Python/Flask designed as a microservice component" {

    !identifiers hierarchical

    model {
        # People
        client = person "Client" "Submits transactions, queries chain state, triggers mining" "User"

        # External Systems (other QBC nodes)
        peerNode = softwareSystem "Peer QBC Node" "Another node in the blockchain network" "External"

        # Main System
        qbc = softwareSystem "Quantum Blockchain Node" "A single QBC node running Flask, managing a local blockchain copy with P2P networking" {

            # Containers
            flaskServer = container "Flask Server" "HTTP server handling all API requests" "Python 2.7 / Flask 1.0.2" "WebApp" {
                # Components (Blueprints)
                transactionsBlueprint = component "Transactions Blueprint" "Handles transaction submission and relay" "Flask Blueprint"
                miningBlueprint = component "Mining Blueprint" "Creates new blocks from pending transactions" "Flask Blueprint"
                chainBlueprint = component "Chain Blueprint" "Serves chain data, accepts broadcasted blocks" "Flask Blueprint"
                networkBlueprint = component "Network Blueprint" "Node discovery and registration" "Flask Blueprint"
            }

            domainLib = container "Domain Library" "Core blockchain logic — chain management, consensus, hashing" "Python" "Library" {
                chainModule = component "Chain" "Blockchain state management, block creation, persistence, sync" "Python class"
                quantModule = component "Quant" "Block definition — index, timestamp, data, hash, proof" "Python class"
                proofModule = component "Proof" "Proof-of-Work consensus and validation" "Python module"
                hashModule = component "Hash" "SHA256 block hashing" "Python module"
                networkModule = component "Network" "P2P discovery, broadcast, chain download" "Python class"
                transactionsModule = component "Transactions" "Transaction pool management and relay" "Python class"
            }

            chainStorage = container "Chain Storage" "Pickle-serialized blockchain file" "storage/q.bc" "Database"
            nodeRegistry = container "Node Registry" "JSON file of known peer nodes" "storage/nodes.json" "Database"
            txPool = container "Transaction Pool" "JSON file of pending transactions" "storage/transactions.json" "Database"
            genesisConfig = container "Genesis Config" "Genesis node addresses" "config/system_preferences.json" "Database"
        }

        # Relationships — System Context
        client -> qbc "Submits transactions, mines blocks, queries chain" "HTTP/REST"
        qbc -> peerNode "Broadcasts blocks, relays transactions, discovers peers" "HTTP"
        peerNode -> qbc "Broadcasts blocks, relays transactions, registers" "HTTP"

        # Relationships — Container level
        client -> qbc.flaskServer "POST /inject, GET /leap, GET /json-chain, GET /stats" "HTTP"
        peerNode -> qbc.flaskServer "PUT /inject, POST /add-block, POST /discover" "HTTP"

        qbc.flaskServer -> qbc.domainLib "Calls domain logic" ""
        qbc.domainLib -> qbc.chainStorage "Reads/writes blockchain" "Pickle"
        qbc.domainLib -> qbc.nodeRegistry "Reads/writes peer list" "JSON"
        qbc.domainLib -> qbc.txPool "Reads/writes pending transactions" "JSON"
        qbc.domainLib -> qbc.genesisConfig "Reads genesis node list" "JSON"
        qbc.domainLib -> peerNode "Broadcasts blocks, relays transactions" "HTTP"

        # Relationships — Component level (Flask -> Domain)
        qbc.flaskServer.transactionsBlueprint -> qbc.domainLib.transactionsModule "Loads/saves transactions"
        qbc.flaskServer.transactionsBlueprint -> qbc.domainLib.networkModule "Broadcasts to peers"
        qbc.flaskServer.miningBlueprint -> qbc.domainLib.chainModule "Creates new block"
        qbc.flaskServer.miningBlueprint -> qbc.domainLib.transactionsModule "Loads pending transactions"
        qbc.flaskServer.miningBlueprint -> qbc.domainLib.networkModule "Broadcasts new block"
        qbc.flaskServer.chainBlueprint -> qbc.domainLib.chainModule "Queries/modifies chain"
        qbc.flaskServer.chainBlueprint -> qbc.domainLib.proofModule "Validates PoW"
        qbc.flaskServer.networkBlueprint -> qbc.domainLib.networkModule "Discovery and registration"

        # Relationships — Domain internal
        qbc.domainLib.chainModule -> qbc.domainLib.quantModule "Creates blocks"
        qbc.domainLib.quantModule -> qbc.domainLib.proofModule "Calculates proof-of-work"
        qbc.domainLib.quantModule -> qbc.domainLib.hashModule "Generates SHA256 hash"
        qbc.domainLib.chainModule -> qbc.chainStorage "Pickle serialize/deserialize"
        qbc.domainLib.networkModule -> qbc.nodeRegistry "Read/write peers"
        qbc.domainLib.transactionsModule -> qbc.txPool "Read/write transactions"
    }

    views {
        systemContext qbc "SystemContext" {
            include *
            autoLayout
            description "System context showing QBC node, clients, and peer nodes"
        }

        container qbc "Containers" {
            include *
            autoLayout
            description "Container view showing Flask server, domain library, and storage"
        }

        component qbc.flaskServer "FlaskComponents" {
            include *
            autoLayout
            description "Flask Blueprint components — HTTP routing layer"
        }

        component qbc.domainLib "DomainComponents" {
            include *
            autoLayout
            description "Domain library components — core blockchain logic"
        }

        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "WebApp" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
            element "Library" {
                background #85bbf0
                color #000000
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
    }
}
