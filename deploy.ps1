### Sample Azure PowerShell Deployment Code ###

#Region Modify Variables
$deploymentName         = "07-02-2022.Cognitive.Services.Deployment"        # Name of the Deployment in Azure
$resourceGroupName      = "<ResourceGroupName>"                             # Resource Group Name
$location               = "<Location>"                                      # Deployment Region
$keyVaultName           = "<KeyVaultName>"                                  # Key Vault Name
$tenantId               = "8c36ff39-b3ac-4751-9700-8e4e61ebf40e"            # Tenant ID
$objectId               = "37587479-2809-4e60-86fb-e9d734f472f4"            # Object ID of the user that is running the deployment
$myPublicIpAddress      = "<PublicIpAddress>"                               # Public IP Address of the Host that is running the deployment
$cognitiveServicesName  = "<CognitiveServicesName>"                         # Cognitive Services Account Name
$keyName1               = "<keyName1>"                                      # Name of the first secret in Key Vault
$keyName2               = "<keyName2>"                                      # Name of the second secret in Key Vault
#Endregion Modify Variables

#Region Prepare Objects and Arrays
$keyVaultPolicies       = @(
                                @{
                                objectId = $objectId
                                tenantId = $tenantId
                                permissions = @{
                                    secrets = @(
                                        "Get"
                                        "List"
                                        "Set"
                                        "Delete"
                                        "Recover"
                                        "Backup"
                                        "Restore"
                                    )
                                }
                                applicationId = ""
                                }
                            )

$keyVaultNetworkAcls    = @{
                                defaultAction =  "deny"
                                bypass = "AzureServices"
                                ipRules = @(
                                    @{
                                        value = $myPublicIpAddress
                                    }
                                )
                                virtualNetworkRules = @() 
                            }
#Endregion Prepare Objects and Arrays

#Region Deploy Resources
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
#Endregion Deploy Resources