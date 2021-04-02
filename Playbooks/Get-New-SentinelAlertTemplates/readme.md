# Get-New-SentinelAlertTemplates
author: Rich Lilly with credit to Adrian Grigorof https://www.managedsentinel.com/2021/03/28/monitor-alert-rules/

This playbook will use a Managed Identity with the Azure Sentinel Reader role (Add under the RG IAM settings the name of the playbook) to retrieve all AlertTemplates from the API once a day and post the details to Teams. You can additional notification methods such as e-mail, social, etc after.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frichlilly2004%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FGet-New-SentinelAlertTemplates%2Fazuredeploy.json" target="_blank">
    <img src="https://aka.ms/deploytoazurebutton""/>
</a>
<a href="https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frichlilly2004%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FGet-New-SentinelAlertTemplates%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.png"/>
</a>