# SmartGlow 101 Support Policy

**Policy version:** 2.0

**Effective date:** August 15, 2026
**Owner:** GlowTech Workshop Operations

## Purpose

This policy defines support and escalation procedures for organizer-provisioned SmartGlow 101 workshop environments. It supersedes support and warranty-claim instructions in Product Manual version 1.0.

## Participant Support

Participants should not run `azd up`, redeploy resources, change role assignments, or restart Azure services during a live workshop. If an assigned environment is unavailable:

1. Confirm that the participant is signed in with the identity listed in the environment assignment.
2. Capture the assigned Foundry project and lightbulb application links.
3. Send the issue to the designated workshop support owner.
4. Continue with the instructor demonstration while the support owner resolves the issue in a breakout room.

## Support Priority

| Severity | Example | Target response |
|---|---|---|
| P1 | Multiple participants cannot access Foundry or the lightbulb application | Immediate instructor and support-owner coordination |
| P2 | One participant has an identity, RBAC, or assigned-link problem | Support-owner triage during the current unit |
| P3 | A nonessential prompt produces an unexpected response | Record for the evaluation and improvement exercise |

## Warranty and Claims

The workshop organizer supports each assigned environment for the scheduled workshop window. Participants should report failures to the support owner rather than attempting to redeploy the environment. The support owner decides whether to repair, replace, or reassign an environment.

## Source Precedence

When this policy conflicts with the SmartGlow 101 Product Manual version 1.0 about participant support, deployment, or warranty claims, follow this newer policy. Product specifications and supported lightbulb capabilities remain governed by the product manual.
