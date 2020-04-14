##Run in Cloud Shell on customer's tenant
$location = "eastus"
New-AzDeployment -Location $location -DeploymentName "SentinelaaS" -TemplateFile "./rgDelegatedResourceManagement.json" -TemplateParameterFile "./Netrix Prod B2B - Azure Sentinel MSSP.json"