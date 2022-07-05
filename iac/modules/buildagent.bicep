// Parameters
@description('Azure location to which the resources are to be deployed')
param location string

@description('The full id string identifying the target subnet for the VM')
param subnetId string

@description('Disk type of the IS disk')
param osDiskType string = 'Standard_LRS'

@description('Valid SKU indicator for the VM')
param vmSize string = 'Standard_D4_v3'

@description('The user name to be used as the Administrator for all VMs created by this deployment')
param username string

@description('The password for the Administrator user for all VMs created by this deployment')
param password string

@description('Windows OS Version indicator')
param windowsOSVersion string = '2016-Datacenter'

@description('Name of the VM to be created')
param vmName string

// Bring in the nic
module nic 'vm-nic.bicep' = {
  name: '${vmName}-nic'
  params: {
    location: location
    subnetId: subnetId
    nicName: '${vmName}-nic'
  }
}

// Create the vm
resource vm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: vmName
  location: location
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        name: '${vmName}-osdisk'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsOSVersion
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: username
      adminPassword: password
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.outputs.nicId
        }
      ]
    }
  }
}

// outputs
output id string = vm.id
