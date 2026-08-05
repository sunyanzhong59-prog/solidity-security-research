# Solidity Security Research

Personal repository documenting Solidity smart contract security research, vulnerability analysis, and audit findings.

## About

This repository serves as a daily log of security research activities, including:
- Smart contract vulnerability analysis
- Audit report drafts and findings
- PoC (Proof of Concept) code
- Security pattern documentation
- Bug bounty submission tracking

## Researcher

- **GitHub:** [sunyanzhong59-prog](https://github.com/sunyanzhong59-prog)
- **Focus Areas:** DeFi protocol security, access control vulnerabilities, bridge contract audits

## Projects Audited

| Project | Platform | Severity | Status | Date |
|---------|----------|----------|--------|------|
| Ethena (StakedUSDeV2) | Immunefi | High | ❌ Known Issues, not payable | 2026-07 |
| Immutable (zkEVM Bridge) | Bugcrowd | High | 🟢 Finding 1 pending review (due 8/6) | 2026-07-18 |
| Immutable (4 findings) | Bugcrowd | — | ❌ Not Applicable (no PoC / admin scope) | 2026-07-21 |
| mETH Protocol | Immunefi | Low | ❌ Out of scope (privileged roles) | 2026-07 |
| Metronome Synth | Immunefi | Low | ⏸️ Pending (KYC blocked) | 2026-07 |
| The Graph | Immunefi | — | ❌ No submittable findings | 2026-07 |
| SSV Network | Immunefi | — | ❌ No submittable findings | 2026-07 |
| Ember Vaults | HackenProof | Medium | ❌ Dead end (50 rep + $0 medium) | 2026-07 |

## Methodology (5 Iron Rules)

1. **Privileged roles = out of scope** — only user-triggerable bugs count
2. **No PoC = instant rejection** — always attach runnable Foundry test (.t.sol)
3. **No attack scenario = no impact** — "as an attacker I could..."
4. **No duplicate submissions** — check title uniqueness first
5. **Don't waste new-account quota** — submit only after PoC verified

## Vulnerability Patterns

See [vulnerability-patterns/README.md](vulnerability-patterns/README.md)

## Daily Notes

See [daily-notes/](daily-notes/)

## License

MIT
