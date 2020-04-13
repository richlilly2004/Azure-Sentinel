# Get-TIfromOTX
author: Rich Lilly, Tom Lilly

This playbook will get TI data from Alienvault OTX NOTE: You must create an app registration with the following permissions (and have an admin consent them) Microsoft Graph > ThreatIndicators.ReadWrite.OwnedBy & WindowsDefenderATP > Ti.ReadWrite.All . Also, retrieve the key and generate a shared secret. Finally, create/login to otx.alienvault.com and retrieve your API key.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frichlilly2004%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FGet-TIfromOTX%2Fazuredeploy.json" target="_blank">
    <img src="https://aka.ms/deploytoazurebutton""/>
</a>
<a href="https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frichlilly2004%2FAzure-Sentinel%2Fmaster%2FPlaybooks%2FGet-TIfromOTX%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.png"/>
</a>