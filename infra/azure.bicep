param resourceBaseName string
param storageSku string

param storageName string = resourceBaseName
param location string = resourceGroup().location

// Azure Storage that hosts your static web site
resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'StorageV2'
  location: location
  name: storageName
  properties: {
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: storageSku
  }
}

resource fluidRelay 'Microsoft.FluidRelay/fluidRelayServers@2022-06-01' = {
  name: 'Test-Fluid-Relay'
  location: location
  identity: {
    type: 'None'
  }
  properties: {
    storagesku: 'standard'
  }
}

resource plan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'test-ASP-TeamsApp-98c4'
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'test-Hc-Key-Vault'
  location: location
  properties: {
    accessPolicies: [
      {
        tenantId: '1faf88fe-a998-4c5b-93c9-210a11d9a5c2'
        objectId: '68441a01-70cb-4f0b-bfe2-87fa645be89c'
        permissions: {
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'ManageContacts'
            'ManageIssuers'
            'GetIssuers'
            'ListIssuers'
            'SetIssuers'
            'DeleteIssuers'
            'Purge'
          ]
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'GetRotationPolicy'
            'SetRotationPolicy'
            'Rotate'
            'Encrypt'
            'Decrypt'
            'UnwrapKey'
            'WrapKey'
            'Verify'
            'Sign'
            'Purge'
            'Release'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'Purge'
          ]
        }       
      }
    ]
    createMode: 'default'
    enablePurgeProtection: true
    enableSoftDelete: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '1faf88fe-a998-4c5b-93c9-210a11d9a5c2'
    vaultUri: 'https://test-holocollab-key-valut.vault.azure.net/'
  }
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: 'test-Fluid-JWT-Provider'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
          {
            name: 'AzureWebJobsFeatureFlags'
            value: 'EnableWorkerIndexing'
          }
          {
            name: 'AzureWebJobsStorage'
            value: 'DefaultEndpointsProtocol=https;AccountName=genericfluidstorage;AccountKey=vKSZOCsXHjXaE36fIm63kQ/+a5aa1kTFmWDCLpoHCMewtXWvmh/DZKWFQn15/trr3hRgNCM5TUgT+ASt0ND6Ig==;EndpointSuffix=core.windows.net'
          }
          {
            name: 'FluidRelayKey'
            value: '@Microsoft.KeyVault(SecretUri=https://holocollab-key-valut.vault.azure.net/secrets/Fluid-Relay-Key1/)'
          }
          {
            name: 'FUNCTIONS_EXTENSION_VERSION'
            value: '~4'
          }
          {
            name: 'FUNCTIONS_WORKER_RUNTIME'
            value: 'node'
          }
          {
            name: 'keyVaultReferenceIdentity'
            value: '/subscriptions/a2f6cb3c-7458-4872-8099-fcd096f29d7f/resourcegroups/Teams-App/provid ers/Microsoft.ManagedIdentity/userAssignedIdentities/Fluid-Relay-MA'
          }
          {
            name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
            value: 'DefaultEndpointsProtocol=https;AccountName=genericfluidstorage;AccountKey=vKSZOCsXHjXaE36fIm63kQ/+a5aa1kTFmWDCLpoHCMewtXWvmh/DZKWFQn15/trr3hRgNCM5TUgT+ASt0ND6Ig==;EndpointSuffix=core.windows.net'
          }
          {
            name: 'WEBSITE_CONTENTSHARE'
            value: 'fluid-jwt-providerb804'
          }
      ]
    }
    httpsOnly: true
  }
}


var siteDomain = replace(replace(storage.properties.primaryEndpoints.web, 'https://', ''), '/', '')

// The output will be persisted in .env.{envName}. Visit https://aka.ms/teamsfx-actions/arm-deploy for more details.
output TAB_AZURE_STORAGE_RESOURCE_ID string = storage.id // used in deploy stage
output TAB_DOMAIN string = siteDomain
output TAB_ENDPOINT string = 'https://${siteDomain}'
