# Error Handling Analysis

## Error Sources

| Source | Type | Example | Handler | Evidence |
|--------|------|---------|---------|----------|
| Block validation | Business logic | Invalid PoW | Inline check, returns error string | modules/chain/controllers.py |
| Network requests | Infrastructure | Node unreachable | Bare try/except | lib/network.py |
| File I/O | Infrastructure | Storage file missing | try/except with fallback | lib/chain.py, lib/transactions.py |
| Chain sync | Network | Peer returns bad data | No handling | lib/network.py:read_chain() |

## Error Handling Patterns

### Pattern 1: Silent Catch (Network Operations)

Network operations catch all exceptions silently:

```python
# lib/network.py — typical pattern
try:
    response = requests.post(node_addr + '/discover', data={'host': this_node})
except:
    pass  # Node unreachable, silently ignored
```

**Assessment**: Appropriate for P2P discovery (nodes come and go), but no logging means network issues are invisible.

### Pattern 2: Fallback to Default (Storage)

Storage operations fall back to empty/default state:

```python
# lib/chain.py — chain loading
try:
    self.load()  # Read from q.bc
except:
    self.__bang()  # Create genesis block
```

**Assessment**: Reasonable for first-run scenario, but masks corruption — a corrupted q.bc file silently creates a new chain, losing all data.

### Pattern 3: Inline Validation (Block Acceptance)

Block acceptance does a single PoW check:

```python
# modules/chain/controllers.py
if validate(current_proof, new_proof):
    chain.add_quant(quant)
    return "Success"
else:
    return "Invalid new block received"
```

**Assessment**: Only validates PoW. Missing: hash chain continuity, index sequencing, timestamp validation, data integrity.

## Error Response Formats

| Endpoint | Success Response | Error Response | HTTP Status |
|----------|-----------------|----------------|-------------|
| POST /inject | `"Transaction submission successful"` | None (no validation) | 200 |
| GET /leap | `"block creation successful"` | None | 200 |
| POST /add-block | `"Success"` | `"Invalid new block received"` | 200 (always) |
| GET /json-chain | JSON array | Flask default 500 | 200/500 |
| POST /discover | JSON object | Flask default 500 | 200/500 |

**Note**: All responses return HTTP 200 regardless of success/failure. Error conditions are communicated only via response body text.

## Logging and Monitoring

| Aspect | Implementation | Notes |
|--------|----------------|-------|
| Logging | Flask debug mode logger | No structured logging |
| Error tracking | None | No Sentry, Bugsnag, etc. |
| Alerting | None | No monitoring infrastructure |
| Metrics | GET /stats (chain length + hash) | Minimal, no error rate tracking |

## Error Handling Gaps

| Scenario | Current Behavior | Risk | Recommendation |
|----------|------------------|------|----------------|
| Corrupted q.bc file | Silently creates new genesis block | Critical | Detect corruption, warn user, backup |
| Pickle deserialization of malicious payload | Arbitrary code execution | Critical | Replace pickle with JSON for network data |
| Node sends invalid chain during sync | Unpickled and accepted if longer | High | Validate chain integrity before accepting |
| Transaction with invalid data | Accepted without validation | High | Add transaction schema validation |
| All nodes unreachable during broadcast | Silent failure, no retry | Medium | Log failures, implement retry with backoff |
| Disk full during save() | Unhandled exception, 500 error | Medium | Catch IOError, alert user |
| Concurrent writes to storage files | Race condition, data loss | Medium | Add file locking or use a proper database |
| Flask debug mode in production | Stack traces exposed to clients | Medium | Disable debug mode for production |

## Recovery Mechanisms

| Mechanism | Implementation | Notes |
|-----------|----------------|-------|
| Chain sync on startup | Yes — downloads longest chain | Provides basic recovery after crash |
| Transaction broadcast retry | No | Failed broadcasts are lost |
| Circuit breaker | No | No protection against failing peers |
| Graceful degradation | Partial — genesis fallback | Only for storage initialization |
