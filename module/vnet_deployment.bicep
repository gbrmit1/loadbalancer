param vnetname string
param vnetaddressprefix string
param vnetlocation string
param tagowner string

resource coreservicesvnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetname
  location:vnetlocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddressprefix
      ]
    }
  }
  
  tags:{
    owner: tagowner
  }
}



