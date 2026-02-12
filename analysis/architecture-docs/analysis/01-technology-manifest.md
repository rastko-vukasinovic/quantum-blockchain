# Technology Manifest

## Languages

| Language | Version | Evidence | Doc Mentioned |
|----------|---------|----------|---------------|
| Python | 2.7 | Dockerfile:1 (`FROM python:2`) | No — README says "Python" without version |

## Frameworks and Libraries

| Package | Version | Category | Purpose |
|---------|---------|----------|---------|
| Flask | 1.0.2 | Web framework | HTTP server, routing via Blueprints |
| Flask-SocketIO | 2.9.3 | WebSocket | Referenced in requirements, not actively used |
| requests | 2.18.4 | HTTP client | Node-to-node communication (broadcast, discovery) |
| gnupg | 2.3.1 | Cryptography | GPG encryption (imported, not implemented) |
| psutil | 5.4.6 | System | System utilities |
| Werkzeug | 3.0.6 | WSGI | Flask dependency (version may conflict with Python 2) |
| pylint | 1.9.2 | Dev tooling | Code quality |
| isort | 4.3.4 | Dev tooling | Import sorting |

## Infrastructure Dependencies

| Component | Type | Implementation | Evidence |
|-----------|------|----------------|----------|
| Blockchain storage | File | Pickle serialization to `storage/q.bc` | lib/chain.py |
| Node registry | File | JSON file at `storage/nodes.json` | lib/network.py |
| Transaction pool | File | JSON file at `storage/transactions.json` | lib/transactions.py |
| Genesis config | File | `config/system_preferences.json` | lib/qbc_utils.py |

## Built-in Standard Library Usage

| Module | Purpose | Location |
|--------|---------|----------|
| hashlib | SHA256 block hashing | lib/hash.py |
| pickle | Chain serialization/deserialization | lib/chain.py |
| socket | IP address detection | lib/qbc_utils.py |
| json | Node/transaction persistence | lib/network.py, lib/transactions.py |
| datetime | Block timestamps | lib/quant.py |
| sys | CLI argument parsing (port) | lib/qbc_utils.py |

## Deployment

| Tool | Version | Purpose | Evidence |
|------|---------|---------|----------|
| Docker | - | Containerization | Dockerfile |
| docker-compose | - | Multi-node test network (3 nodes) | docker-compose.yaml |
