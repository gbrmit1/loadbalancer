// public IP params
param dnsLabelPrefix string = 'ihopethisworks'
param publicIpName string = 'myPublicIPBastion'
param publicIPAllocationMethod string = 'Static'
param publicIpSku string = 'Standard'

// General Params
param location string = 'northeurope'


resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: 'IntLB-VNet/AzureBastionSubnet'
}



resource bastion 'Microsoft.Network/bastionHosts@2022-07-01' = {
  name: 'myBastionHost'
  location:location
  sku:{
    name:'Standard'
  }
  properties: {
    enableIpConnect:true
    ipConfigurations:[
      {
        name: 'bastionIpConfigurations'
        properties:{
          privateIPAllocationMethod:'Dynamic'
          publicIPAddress:{
            id:pip.id
          }
          subnet:{
            id:bastionSubnet.id
          }
        }
      }
    ]
  }
}
