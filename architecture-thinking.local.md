# Architecture Thinking — Project Overrides

> **Instructions for AI agent**: Read this file AFTER the toolkit's
> `core/architecture-thinking.md`. Apply the following rules:
>
> - **Matching headings** REPLACE the corresponding section in the default
> - **New headings** are ADDED to the mental model
> - **Sections listed under `## Skip`** are IGNORED from the default

---

## Skip

- Enterprise Continuum

---

## Architecture Domains

### Consensus Architecture

The mechanism by which distributed nodes agree on the state of the blockchain.

- **Proof Systems**: Proof-of-Work (current), Proof-of-Stake, Delegated Block Creation
- **Block Validation**: Hash integrity, proof verification, chain continuity
- **Fork Resolution**: Longest-chain rule, conflict detection, chain reorganization
- **Finality**: When a block is considered permanently committed

**Questions to ask**:
- What consensus mechanism is used? What are its security properties?
- How are forks detected and resolved?
- What is the finality model? How many confirmations are needed?
- What is the cost of a 51% attack under the current PoW?

### Network Topology

How nodes discover, connect to, and communicate with each other.

- **Node Discovery**: Bootstrap nodes, peer registration, gossip protocol
- **Synchronization**: Chain download, longest-chain selection, catch-up on startup
- **Broadcasting**: Block propagation, transaction relay, network-wide consistency
- **Partitioning**: Split-brain scenarios, network healing, consistency vs availability

**Questions to ask**:
- How does a new node join the network?
- What happens during a network partition?
- How quickly do new blocks propagate to all nodes?
- What is the maximum network size the current discovery mechanism supports?

---

## Risk Analysis

### Additional Risk Categories

| Category | Risks |
|----------|-------|
| **Consensus** | 51% attack feasibility, nothing-at-stake, selfish mining |
| **Serialization** | Pickle deserialization from untrusted peers, data integrity |
| **Network** | Sybil attacks, eclipse attacks, partition tolerance |
