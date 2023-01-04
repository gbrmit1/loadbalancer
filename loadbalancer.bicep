param name  string = 'myIntLoadBalancer'
param location string = 'northeurope'
param sku string = 'Standard'
param tier string = 'Regional'
param lbfrontend string = 'LoadBalancerFrontEnd'

resource lbbackendsubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: 'IntLB-VNet/myBackendSubnet'
}

resource lbvirtualnetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: 'IntLB-VNet'
}
resource lbbackendVm1Nic1 'Microsoft.Network/networkInterfaces@2018-06-01' existing = {
  name: 'myVMnic1'
}
resource lbbackendVm1Nic2 'Microsoft.Network/networkInterfaces@2018-06-01' existing = {
  name: 'myMV2nic2'
}
resource lbbackendVm1Nic3 'Microsoft.Network/networkInterfaces@2018-06-01' existing = {
  name: 'myVMnic3'
}



resource lb 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: name
  location:location
  properties: {
    
    frontendIPConfigurations: [
      {
        name: lbfrontend
        properties: {
          privateIPAddress:'null'
          privateIPAddressVersion:'IPv4'
          privateIPAllocationMethod:'Dynamic'
          subnet:{
            id:lbbackendsubnet.id
          }
        }
        zones:[
          '1'
          '2'
          '3'
        ]
      }
    ]
    backendAddressPools: [
      {
        name:'myBackendPool'
        properties: {
          virtualNetwork: {
            id:lbvirtualnetwork.id
          }
          loadBalancerBackendAddresses: [
            {
              name:lbbackendVm1Nic1.properties.ipConfigurations[0].properties.privateIPAddress // I think this is correct
            }
            {
              name:lbbackendVm1Nic2.properties.ipConfigurations[0].properties.privateIPAddress // I think this is correct
            }
            {
              name:lbbackendVm1Nic3.properties.ipConfigurations[0].properties.privateIPAddress // I think this is correct
            }
          ]
        }
      }
    ]

    loadBalancingRules: [
      {
        name:'myHTTPRule'
        properties: {
          frontendIPConfiguration: {
            id:resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations',name, lbfrontend)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, 'myBackendPool')
          }
          frontendPort: 80
          protocol: 'Tcp'
          backendPort: 80
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', name, 'myHealthProbe')
          }
          idleTimeoutInMinutes:15
          enableFloatingIP:false
        }
      }
    ]
    probes: [
      {
        name:'myHealthProbe'
        properties: {
          port: 80
          protocol: 'Http'
          requestPath:'/'
          intervalInSeconds:15
          probeThreshold:2
        }
      }
    ]
  }
  sku:{
    name:sku
    tier:tier
  }

}


