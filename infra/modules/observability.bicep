@description('Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Name of the Application Insights resource')
param applicationInsightsName string

@description('Name of the Foundry account')
param foundryAccountName string

@description('Name of the Foundry project')
param foundryProjectName string

@description('Principal ID of the workshop user who needs access to telemetry')
param foundryUserPrincipalId string

@description('Azure region for resources')
param location string

@description('Tags to apply to resources')
param tags object = {}

var connectionName = 'application-insights-project'
var telemetryReaderRoleDefinitionIds = [
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893') // Log Analytics Reader
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dbc9c667-e97f-4491-aee6-90b9cf960190') // Privileged Monitoring Data Reader
]

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  tags: tags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: foundryAccountName
}

resource foundryProject 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' existing = {
  parent: foundryAccount
  name: foundryProjectName
}

resource projectApplicationInsightsConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = {
  parent: foundryProject
  name: connectionName
  properties: {
    authType: 'ApiKey'
    category: 'AppInsights'
    credentials: {
      key: applicationInsights.properties.ConnectionString
    }
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: applicationInsights.id
    }
    target: applicationInsights.id
  }
}

resource projectTelemetryReaderRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in telemetryReaderRoleDefinitionIds: {
    scope: applicationInsights
    name: guid(applicationInsights.id, foundryProject.id, roleDefinitionId)
    properties: {
      principalId: foundryProject.identity.principalId
      principalType: 'ServicePrincipal'
      roleDefinitionId: roleDefinitionId
    }
  }
]

resource userTelemetryReaderRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in telemetryReaderRoleDefinitionIds: {
    scope: applicationInsights
    name: guid(applicationInsights.id, foundryUserPrincipalId, roleDefinitionId)
    properties: {
      principalId: foundryUserPrincipalId
      principalType: 'User'
      roleDefinitionId: roleDefinitionId
    }
  }
]

output applicationInsightsName string = applicationInsights.name
output applicationInsightsId string = applicationInsights.id
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
