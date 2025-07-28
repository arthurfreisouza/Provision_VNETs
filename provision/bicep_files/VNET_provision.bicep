targetScope = 'resourceGroup'

param location string = 'eastus'

var appVnetName = 'app-vnet'
var hubVnetName = 'hub-vnet'

resource appVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: appVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'frontend'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
      {
        name: 'backend'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]
  }
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.0.0/26'
        }
      }
    ]
  }
}


resource appToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: appVnet
  name: 'app-vnet-to-hub'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
  }
}

resource hubToAppPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: hubVnet
  name: 'hub-to-app-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: appVnet.id
    }
  }
}

output appVnetName string = appVnet.name
output hubVnetName string = hubVnet.name
