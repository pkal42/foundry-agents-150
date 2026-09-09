# SmartGlow 101 Workshop Operations Runbook

**Runbook version:** 1.1

**Last reviewed:** August 20, 2026
**Audience:** Workshop organizers and support owners

## Environment Health Check

Before the workshop, confirm that every assigned environment has:

- A reachable Microsoft Foundry project
- A healthy SmartGlow web application
- Grounding with Bing
- All three SmartGlow workshop files uploaded to the agent
- Application Insights connected to the Foundry project
- A Log Analytics workspace
- Required participant and project-identity role assignments
- A versioned Unit 7 evaluation dataset

If the optional Foundry IQ exercise is enabled, also confirm that an Azure AI Search S1 service and the prepared knowledge base are connected to the Foundry project.

## Common Incidents

### Participant cannot open the Foundry project

1. Verify the participant is using the assigned identity.
2. Verify the environment assignment link.
3. Confirm the participant has the Foundry User role.
4. Reassign the participant to a spare validated environment if access cannot be restored within five minutes.

### Lightbulb application loads but MCP does not connect

1. Open the application health endpoint and confirm the backend is running.
2. Confirm the MCP URL ends in `/mcp`.
3. Confirm the connection uses Streamable HTTP.
4. Review App Service logs for startup or transport errors.
5. Do not expose credentials or secrets in workshop chat.

### Agent cannot retrieve curated knowledge

1. Confirm all three uploaded workshop files are visible in the agent's knowledge configuration.
2. Confirm file processing completed after the latest upload.
3. If the optional Foundry IQ path is enabled, confirm the Azure AI Search connection and knowledge base are online.
4. Confirm citations identify the expected source and version.
5. Review the trace to distinguish retrieval failure from instruction-routing failure.

### Traces are unavailable

1. Confirm Application Insights is connected to the Foundry project.
2. Verify the user has Log Analytics Reader and Privileged Monitoring Data Reader.
3. Generate a new agent interaction and allow time for ingestion.
4. Never paste trace contents containing participant prompts into a public channel.

## Escalation Data

Capture only the minimum information needed:

- Environment assignment identifier
- Affected resource or portal
- Timestamp and correlation identifier
- Error message with secrets and personal data removed
- Whether the issue affects one or multiple participants

Do not capture passwords, access tokens, connection strings, or unnecessary participant data.
