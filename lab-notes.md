# Lab notes: Zero Trust DevSecOps POC

## IDs

| Item | Value |
| --- | --- |
| Subscription name | Azure for Students |
| Subscription ID | eb726bdd-8dae-4521-9746-083042e7d3c5 |
| Tenant ID | 1211f716-5b0b-4bfe-b7c9-8e0045b37e3e |
| My role on the subscription | Owner |
| Azure for Students credit expires | 20/11/2027 |
| Allowed regions | ["switzerlandnorth","austriaeast","swedencentral","belgiumcentral","spaincentral"] |
| Chosen REGION | swedencentral |
| SUFFIX | ds2003 |

### Pinned scanner images

| Variable | Image reference |
| --- | --- |
| BETTERLEAKS_IMAGE | ghcr.io/betterleaks/betterleaks@sha256:c4955cc2a56492588a319e65577bc1bb4435704678aed8b1c4d78ad803476544 |
| KICS_IMAGE | checkmarx/kics@sha256:49ccc54b6ae7f5d5fc95e96f8f95c18c57f3bba047ab611a03d80792bdff6757 |
| TRIVY_IMAGE | aquasec/trivy@sha256:8f6bb947dbc528902e11f2f5be52f7b519f6a39d5d148f41166f2040499768fb |

## Decisions

- 2026-11-21: Ansible instead of Terraform, at the coordinator's suggestion; one tool provisions, detects drift (check mode) and remediates.
- 2026-11-21: Betterleaks v2.0.0-rc.8, pinned by digest. Stable v2 is not released yet; pinning keeps results consistent. Switch to stable only if it ships before Phase 9 experiments start.
- 2026-11-21: Pre-commit hook scans staged changes through Betterleaks stdin mode, because rc.8's git command has no staged-only option.
- 2026-11-21: Trivy 0.76.2, well past the compromised 0.69.4 release.
- 2026-11-21: All tools run in WSL2 Ubuntu 24.04; project files live under ~/projects, not /mnt/c.
- 2026-11-21: Node 24 LTS instead of 22: 22's support ends 2027-04-30, before submission

## Errors and fixes

- 2026-11-21: apt "Could not get lock": Ubuntu was installing updates in the background. Fix: waited for the lock to clear, re-ran apt.
- 2026-11-21: apt update failed on an old OpenVidu repository (403, unsigned). Fix: renamed its source file to .disabled.
- 2026-11-21: Ubuntu's gh 2.45 lacks "gh attestation verify" (needs 2.49+). Fix: installed gh from GitHub's official apt repository.
- 2026-11-21: "exec bash" inside a pasted block discarded the remaining commands. Fix: run one group at a time; use "source ~/.bashrc" instead.
- 2026-11-21: ghcr.io/betterleaks/betterleaks:v2 not found: no stable v2 tag exists yet. Fix: used v2.0.0-rc.8.

## Experiment log

(Empty until Phase 9.)
