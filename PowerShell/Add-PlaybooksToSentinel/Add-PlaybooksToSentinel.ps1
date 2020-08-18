<#
Add-PlaybooksToSentinel.ps1
Authors: Tom Lilly @tlilly2010 (@TheTomLilly), Rich Lilly @richlilly2004 (@richlilly) - Netrix LLC (https://www.netrixllc.com)
From https://github.com/Azure/Azure-Sentinel/PLACEHOLDER
Last Updated Date: August 18, 2020

This PowerShell script will enumerate a local Github repository clone of https://github.com/Azure/Azure-Sentinel/Playbook, 
ask for a multi-select of the playbooks to import and import them.
At the time of authoring, additional API authorization will have to be completed, but this is being worked on :)

Select your Playbooks, Subscription, LA instance, Resource Group, Sentinel instance, Username (for assignment)
NOTE: If there is a non-standard parameter (ie not playbook name or username, you will prompted for that field entry (ie API key, etc))

Profit :)

Reqirements: Github repo synced locally, PowerShell Module Az.Resources
Directory: Specify local cloned repo, ie C:\Github\Azure-Sentinel\Playbooks
Permissions: Contributor on the Resource Group
#>
#Requires -Module Az.Resources

$repoDirectory = Read-Host -Prompt "Enter the directory containing all playbooks to deploy"
$playbooks = Get-ChildItem -LiteralPath $repoDirectory |Where-Object {$_.Name -notlike "*.*"} | Select-Object Name | Out-GridView -Title "Select Playbooks to Deploy" -PassThru

Connect-AzAccount

$subscription = Get-AzSubscription | Out-GridView -Title "Select Subscription to Deploy Playbooks to" -PassThru
Select-AzSubscription -SubscriptionName $subscription.Name
$rg = Get-AzResourceGroup | Out-GridView -Title "Select Resource Group to Deploy Playbooks to" -PassThru

$workspace = Get-AzResource -ResourceGroupName $rg.ResourceGroupName -ResourceType "Microsoft.OperationalInsights/workspaces" | Out-GridView -Title "Select Sentiel Workspace" -PassThru

$userName = Read-Host -Prompt "Enter the Username to use for Sentinel connections"

foreach($playbook in $playbooks)
{
    $template = "$repoDirectory\$($playbook.Name)\azuredeploy.json"
    $templateObj = Get-Content $template |ConvertFrom-Json
    $params = $templateObj.parameters | Get-Member -MemberType NoteProperty | Select-Object Name
    Write-Host "Sentinel Workbook: $($playbook.Name)"
    Write-Host "Parameters: $($params.Name)"
    $templateParamTable = @{}
    foreach($param in $params.Name)
    {
        switch ($param) {
            UserName {
                $templateParamTable.Add($param, $userName)
            }
            AzureSentinelResourceGroup {
                $templateParamTable.Add($param, $rg.ResourceGroupName)
            }
            AzureSentinelSubscriptionID {
                $templateParamTable.Add($param, $subscription.Id)
            }
            AzureSentinelWorkspaceId {
                $templateParamTable.Add($param, $workspace)
            }
            AzureSentinelWorkspaceName {
                $templateParamTable.Add($param, $workspace.Name)
            }
            AzureSentinelLogAnalyticsWorkspaceName {
                $templateParamTable.Add($param, $workspace.Name)
            }
            AzureSentinelLogAnalyticsWorkspaceResourceGroupName {
                $templateParamTable.Add($param, $rg.ResourceGroupName)
            }
            PlaybookName {
                $templateParamTable.Add($param, $playbook.Name)
            }
            Default {
                Write-Host -ForegroundColor Red "Unrecognized parameter: $param"
                $value = Read-Host "Provide value for parameter $param"
                $templateParamTable.Add($param, $value)
            }
        }
    }

    New-AzResourceGroupDeployment -Name "SentinelPlaybook-$($playbook.Name)" -ResourceGroupName $rg.ResourceGroupName -TemplateFile $template -TemplateParameterObject $templateParamTable
}

Function Show-OAuthWindow {
    Add-Type -AssemblyName System.Windows.Forms
 
    $form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=600;Height=800}
    $web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=580;Height=780;Url=($url -f ($Scope -join "%20")) }
    $DocComp  = {
            $Global:uri = $web.Url.AbsoluteUri
            if ($Global:Uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
    }
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocComp)
    $form.Controls.Add($web)
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
}

<#
$connections = Get-AzResource -ResourceType "Microsoft.Web/connections" -ResourceGroupName $rg.ResourceGroupName

foreach($connection in $connections)
{
    $parameters = @{
        "parameters" = ,@{
        "parameterName"= "token";
        "redirectUrl"= "https://ema1.exp.azure.com/ema/default/authredirect"
        }
    }

    $consentResponse = Invoke-AzResourceAction -Action "listConsentLinks" -ResourceId $connection.ResourceId -Parameters $parameters -Force

    $url = $consentResponse.Value.Link 

    Show-OAuthWindow -URL $url

    $regex = '(code=)(.*)$'
    $code  = ($uri | Select-string -pattern $regex).Matches[0].Groups[2].Value
    Write-output "Received an accessCode: $code"

    if (-Not [string]::IsNullOrEmpty($code)) {
        $parameters = @{ }
        $parameters.Add("code", $code)
        # NOTE: errors ignored as this appears to error due to a null response

        #confirm the consent code
        Invoke-AzResourceAction -Action "confirmConsentCode" -ResourceId $connection.ResourceId -Parameters $parameters -Force -ErrorAction Ignore
    }

    #retrieve the connection
    $connection = Get-AzResource -ResourceType "Microsoft.Web/connections" -ResourceGroupName $ResourceGroupName -ResourceName $ConnectionName
    Write-Host "connection status now: " $connection.Properties.Statuses[0]
}
#>