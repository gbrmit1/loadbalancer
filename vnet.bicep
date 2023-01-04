
@sys.batchSize(1)
module vnet_deployments './module/vnet_deployment.bicep' = {
  name: 'test-lb-vn-deploy'
  params: {
    vnetname: 'IntLB-VNet'
    vnetaddressprefix: '10.1.0.0/16'
    vnetlocation: 'northeurope'
    tagowner: 'robert mitchell'
  }
}
