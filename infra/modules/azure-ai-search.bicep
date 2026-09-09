@description('Name of the Azure AI Search service')
param searchServiceName string

@description('Name of the Foundry account')
param foundryAccountName string

@description('Name of the Foundry project')
param foundryProjectName string

@description('Principal ID of the workshop user who manages curated knowledge')
param foundryUserPrincipalId string

@description('Azure region for resources')
param location string

@description('Tags to apply to resources')
param tags object = {}

var connectionName = 'azure-ai-search'
var cognitiveServicesUserRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a97b65f3-24c7-4388-baec-2e87135dc908')
var searchContributorRoleDefinitionIds = [
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8ebe5a00-799e-43f5-93ac-243d3dce84a7') // Search Index Data Contributor
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0') // Search Service Contributor
]

resource searchService 'Microsoft.Search/searchServices@2025-05-01' = {
  name: searchServiceName
  location: location
  tags: tags
  sku: {
    name: 'standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    disableLocalAuth: true
    hostingMode: 'Default'
    partitionCount: 1
    publicNetworkAccess: 'enabled'
    replicaCount: 1
    semanticSearch: 'standard'
  }
}

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: foundryAccountName
}

resource foundryProject 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' existing = {
  parent: foundryAccount
  name: foundryProjectName
}

resource projectSearchConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = {
  parent: foundryProject
  name: connectionName
  properties: {
    authType: 'AAD'
    category: 'CognitiveSearch'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: searchService.id
      location: searchService.location
    }
    target: searchService.properties.endpoint
  }
}

resource searchModelUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: foundryAccount
  name: guid(foundryAccount.id, searchService.id, cognitiveServicesUserRoleDefinitionId)
  properties: {
    principalId: searchService.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: cognitiveServicesUserRoleDefinitionId
  }
}

resource projectSearchRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in searchContributorRoleDefinitionIds: {
    scope: searchService
    name: guid(searchService.id, foundryProject.id, roleDefinitionId)
    properties: {
      principalId: foundryProject.identity.principalId
      principalType: 'ServicePrincipal'
      roleDefinitionId: roleDefinitionId
    }
  }
]

resource userSearchRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in searchContributorRoleDefinitionIds: {
    scope: searchService
    name: guid(searchService.id, foundryUserPrincipalId, roleDefinitionId)
    properties: {
      principalId: foundryUserPrincipalId
      principalType: 'User'
      roleDefinitionId: roleDefinitionId
    }
  }
]

output searchServiceName string = searchService.name
output searchServiceEndpoint string = searchService.properties.endpoint
output searchConnectionName string = projectSearchConnection.name
