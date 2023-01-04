var subnets = [
  {
    name: 'myBackendSubnet'
    subnetPrefix:'10.1.0.0/24'
  }
  {
    name: 'myFrontEndSubnet'
    subnetPrefix:'10.1.2.0/24'
  }
  {
    name: 'AzureBastionSubnet'
    subnetPrefix:'10.1.1.0/24'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: 'IntLB-VNet'
}


@batchSize(1)

resource Subnets 'Microsoft.Network/virtualNetworks/subnets@2022-07-01'= [for sn in subnets: {
  name:sn.name
  parent:vnet
  properties:{
    addressPrefix:sn.subnetPrefix
  }
  
}]


