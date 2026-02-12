# Interface Specification

## External API Endpoints

### POST /inject — Submit Transaction

| Aspect | Detail |
|--------|--------|
| **Purpose** | Add transaction to the pool |
| **Request** | `data={JSON string}` (form-encoded) |
| **Response** | `"Transaction submission successful"` |
| **Auth** | None |
| **Evidence** | modules/transactions/controllers.py |

### PUT /inject — Receive Broadcasted Transaction

| Aspect | Detail |
|--------|--------|
| **Purpose** | Accept transaction relayed from another node |
| **Request** | `data={JSON string}` (form-encoded) |
| **Response** | `"Transaction submission successful"` |
| **Auth** | None |
| **Evidence** | modules/transactions/controllers.py |

### GET /leap — Mine Block

| Aspect | Detail |
|--------|--------|
| **Purpose** | Create new block from all pending transactions |
| **Response** | `"block creation successful"` |
| **Side effects** | Broadcasts new block to all nodes, clears transaction pool |
| **Auth** | None |
| **Evidence** | modules/mining/controllers.py |

### POST /add-block — Receive Broadcasted Block

| Aspect | Detail |
|--------|--------|
| **Purpose** | Accept new block from network |
| **Request** | Pickle-serialized Quant object |
| **Response** | `"Success"` or `"Invalid new block received"` |
| **Validation** | Proof-of-Work check only |
| **Auth** | None |
| **Evidence** | modules/chain/controllers.py |

### GET /json-chain — Get Chain (JSON)

| Aspect | Detail |
|--------|--------|
| **Purpose** | Return full blockchain as JSON array |
| **Response** | Array of blocks: `[{index, timestamp, data, hash, proof, previous_hash}, ...]` |
| **Auth** | None |
| **Evidence** | modules/chain/controllers.py |

### GET /chain — Get Chain (Pickle)

| Aspect | Detail |
|--------|--------|
| **Purpose** | Return full blockchain as pickle-serialized binary |
| **Response** | Binary pickle data |
| **Auth** | None |
| **Evidence** | modules/chain/controllers.py |

### GET /stats — Chain Statistics

| Aspect | Detail |
|--------|--------|
| **Purpose** | Return chain length and hash |
| **Response** | `{length: int, hash: string}` |
| **Auth** | None |
| **Evidence** | modules/chain/controllers.py |

### POST /discover — Register Node

| Aspect | Detail |
|--------|--------|
| **Purpose** | Register a new node on this node's network |
| **Request** | `host={node_address}` (form-encoded) |
| **Response** | `{live_nodes: [...], stats: {length, hash}}` |
| **Auth** | None |
| **Evidence** | modules/network/controllers.py |

### GET /discover — List Known Nodes

| Aspect | Detail |
|--------|--------|
| **Purpose** | Return list of known live nodes |
| **Response** | Array of node addresses |
| **Auth** | None |
| **Evidence** | modules/network/controllers.py |

## Internal Service Interfaces

### Node-to-Node Communication

| Operation | Protocol | Format | Evidence |
|-----------|----------|--------|----------|
| Block broadcast | HTTP POST /add-block | Pickle | lib/network.py:broadcast_quant() |
| Transaction relay | HTTP PUT /inject | Form-encoded | lib/transactions.py:broadcast_transaction() |
| Node discovery | HTTP POST /discover | Form-encoded | lib/network.py:register_and_discover() |
| Chain download | HTTP GET /chain | Pickle | lib/network.py:read_chain() |
| Stats check | HTTP GET /stats | JSON | lib/network.py:discover_network() |

## OpenAPI Specification

An OpenAPI spec exists at `documentation/open-api/qbc.yaml` (Swagger 2.0, v1.0.0). It covers the `/inject` endpoint but is incomplete — most endpoints are not documented in the spec.
