# Quantum Blockchain — AI Agent Config

> Read the toolkit's [AGENTS.md](.ai-toolkit/AGENTS.md) for the full reading order.

## Project Type

Python/Flask blockchain microservice — distributed P2P system with mining, transaction handling, and node discovery.

## Enabled Skills

- [x] codebase-analysis
- [x] arch-analysis
- [x] security-analysis
- [x] structurizr
- [x] fitness-functions
- [ ] nonfunctional-analysis
- [ ] togaf-preliminary
- [ ] togaf-phase-a
- [ ] togaf-phase-b
- [ ] togaf-phase-c
- [ ] togaf-phase-d
- [ ] togaf-phase-e
- [ ] togaf-phase-f
- [ ] togaf-phase-g
- [ ] togaf-phase-h
- [ ] architecture-synthesis
- [ ] presentation

## Architecture Mental Model

This project uses a **custom override** of the default mental model.
See [architecture-thinking.local.md](architecture-thinking.local.md) for project-specific domains (Consensus Architecture, Network Topology) and skipped sections.

## Conventions

- Python 2.7 codebase (legacy — migration to Python 3 is planned)
- Flask Blueprints for route organization
- File-based persistence (pickle for chain, JSON for nodes/transactions)
- No automated tests yet — Docker Compose for integration testing
