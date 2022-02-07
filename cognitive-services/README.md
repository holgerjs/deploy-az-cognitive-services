# Templates and Code Snippets for Azure AI Service Deployments

This repository contains ARM templates and/or PowerShell code for deploying Azure AI Services in a test environment and play around with the configuration.

## Cognitive Services

The ARM template can be used to deploy an Azure KeyVault and a Cognitive Services Account. As recommended by Microsoft, the Access Keys are stored in the Key Vault to remove the need to add them directly into the application code.

A few details are needed for executing a resource group deployment based on this template:

* Tenant ID
* Object ID of the user running the deployment
* Public IP Address of the host that is running the deployment (there are several ways to find this out, i.E. `curl -4 ifconfig.co` )

The values can be either put into the azuredeploy.parameter.json file or added when executing the deployment from PowerShell (see deploy.ps1 for a sample):

```azurepowershell
New-AzResourceGroupDeployment -Name $deploymentName `
                              -ResourceGroupName $resourceGroupName `
                              -location $location `
                              -Mode Incremental `
                              -TemplateFile .\azuredeploy.json `
                              -TemplateParameterFile .\azuredeploy.parameter.json `
                              -keyVaultName $keyVaultName `
                              -keyVaultTenant $tenantId `
                              -keyVaultAccessPolicies $keyVaultPolicies `
                              -keyVaultNetworkAcls $keyVaultNetworkAcls `
                              -csName $cognitiveServicesName `
                              -secretName1 $keyName1 `
                              -secretName2 $keyName2
```
