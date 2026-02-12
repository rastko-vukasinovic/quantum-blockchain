# Quantum Blockchain — Project Context

## Overview

A general-purpose blockchain system implemented in Python/Flask, designed to run as a microservice component. Supports transaction injection, block mining (Proof-of-Work), P2P node discovery, and chain synchronization.

## Architecture Summary

```
Flask Server (run.py)
├── modules/           ← Flask Blueprints (HTTP layer)
│   ├── transactions/  ← POST /inject
│   ├── mining/        ← GET /leap (mine block)
│   ├── chain/         ← GET /json-chain, /stats, POST /add-block
│   └── network/       ← POST/GET /discover
├── lib/               ← Core domain logic
│   ├── chain.py       ← Blockchain state management
│   ├── quant.py       ← Block definition
│   ├── proof.py       ← Proof-of-Work consensus
│   ├── network.py     ← P2P discovery & broadcast
│   ├── transactions.py← Transaction pool
│   └── hash.py        ← SHA256 hashing
├── storage/           ← File-based persistence
│   ├── q.bc           ← Pickle-serialized chain
│   ├── nodes.json     ← Known peers
│   └── transactions.json ← Pending transactions
└── config/            ← Genesis node configuration
```

## Tech Stack

- **Language:** Python 2.7
- **Framework:** Flask 1.0.2
- **Serialization:** pickle (chain), JSON (nodes, transactions)
- **Hashing:** SHA256 (hashlib)
- **Deployment:** Docker, docker-compose (3-node test network)

## API Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| POST | /inject | Submit transaction |
| PUT | /inject | Receive broadcasted transaction |
| GET | /leap | Mine new block from pending transactions |
| GET | /json-chain | Get chain as JSON |
| GET | /chain | Get chain as pickle |
| GET | /stats | Chain length + hash |
| POST | /add-block | Receive broadcasted block |
| POST/GET | /discover | Register/discover nodes |

## Known Issues & Gaps

- **No authentication** — all endpoints are open
- **Simple PoW** — divisibility check, not cryptographically strong
- **Pickle deserialization** — security risk from untrusted nodes
- **No input validation** — transactions accepted without verification
- **No automated tests** — only Docker Compose integration testing
- **Python 2 EOL** — needs migration to Python 3
- **No rate limiting** — vulnerable to DoS

## Current State

Working prototype. Nodes can discover each other, sync chains, mine blocks, and broadcast transactions. Core blockchain mechanics functional but not production-hardened.
