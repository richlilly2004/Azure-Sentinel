#Requires -Modules AzureAD

<#
Created by: Tom Lilly, Netrix, LLC
Twitter: @TheTomLilly
GitHub: tlilly2010

This module automatically creates all required groups in Azure AD for onboarding Sentinel clients to Lighthouse and generates the required parameters file
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $clientName,

    [string]
    $rgName = "REPLACE ME WITH SENTINEL RG NAME"
)

function Save-File([string] $initialDirectory, [string] $initialFileName) 
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "JSON files (*.json)| *.json"
    $OpenFileDialog.FileName = $initialFileName
    $OpenFileDialog.ShowDialog() |  Out-Null

    return $OpenFileDialog.filename
}

$groupPrefix = "SentinelaaS"
$groupSuffixContrib = "Contributors"
$groupSuffixResponders = "Responders"
$groupSuffixReaders = "Readers"
$aadTenantId = "f224c3c9-5f00-44e8-babd-133e9cd928d1"
$contributorRoleIds = @(
    "ab8e14d6-4a74-4a29-9ba8-549422addade",
    "87a39d53-fc1b-424a-814c-f7e04687dc9e",
    "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
)
$responderRoleIds = @(
    "3e150937-b8fe-4cfb-8069-0eaf05ecd056",
    "515c2055-d9d4-4321-b1b9-bd0c9a0f79fe",
    "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
)
$readerRoleIds = @(
    "8d289c81-5878-46d4-8554-54e1e3d8b5cb",
    "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
)

$groupNameContrib = "$groupPrefix - $clientName $groupSuffixContrib"
$groupNameResponders = "$groupPrefix - $clientName $groupSuffixResponders"
$groupNameReaders = "$groupPrefix - $clientName $groupSuffixReaders"
$fileName = "Netrix Prod B2B - Azure Sentinel MSSP-$clientName.json"
$fileDir = "C:\"

Connect-AzureAD -TenantId $aadTenantId

$groupObjContrib = New-AzureADGroup -DisplayName $groupNameContrib -MailEnabled $false -SecurityEnabled $true -MailNickName ($groupNameContrib.Replace(" ",""))
$groupObjResponders = New-AzureADGroup -DisplayName $groupNameResponders -MailEnabled $false -SecurityEnabled $true -MailNickName ($groupNameResponders.Replace(" ",""))
$groupObjReaders = New-AzureADGroup -DisplayName $groupNameReaders -MailEnabled $false -SecurityEnabled $true -MailNickName ($groupNameReaders.Replace(" ",""))

$fileHashTableParamOfferName = @{"value"="Netrix Managed Services - Azure SentinelaaS"}
$fileHashTableParamOfferDescription = @{"value"="Netrix Managed Services - Azure SentinelaaS"}
$fileHashTableParamTenantId = @{"value"=$aadTenantId}
$fileHashTableParamRgName = @{"value"=$rgName}

$fileHashTableAuthArray = New-Object -TypeName System.Collections.ArrayList

#Add Contributor Roles to Params File
foreach($roleId in $contributorRoleIds)
{
    $authHash = @{}
    $authHash.Add("principalId",$($groupObjContrib.objectId))
    $authHash.Add("principalDisplayName",$groupNameContrib)
    $authHash.Add("roleDefinitionId",$roleId)
    $fileHashTableAuthArray.Add($authHash) | Out-Null
}

#Add Responder Roles to Params file
foreach($roleId in $responderRoleIds)
{
    $authHash = @{}
    $authHash.Add("principalId",$($groupObjResponders.objectId))
    $authHash.Add("principalDisplayName",$groupNameResponders)
    $authHash.Add("roleDefinitionId",$roleId)
    $fileHashTableAuthArray.Add($authHash) | Out-Null
}

#Add Reader Roles to Params file
foreach($roleId in $readerRoleIds)
{
    $authHash = @{}
    $authHash.Add("principalId",$($groupObjReaders.objectId))
    $authHash.Add("principalDisplayName",$groupNameReaders)
    $authHash.Add("roleDefinitionId",$roleId)
    $fileHashTableAuthArray.Add($authHash) | Out-Null
}

$fileHashTableParamAuthorizations = @{"value"=$fileHashTableAuthArray}

$fileHashTableParam = @{}
$fileHashTableParam.Add("mspOfferName",$fileHashTableParamOfferName)
$fileHashTableParam.Add("mspOfferDescription",$fileHashTableParamOfferDescription)
$fileHashTableParam.Add("managedByTenantId",$fileHashTableParamTenantId)
$fileHashTableParam.Add("rgName",$fileHashTableParamRgName)
$fileHashTableParam.Add("authorizations",$fileHashTableParamAuthorizations)

$fileHashTable = @{}
$fileHashTable.Add("`$schema","https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentParameters.json#")
$fileHashTable.Add("contentVersion","1.0.0.0")
$fileHashTable.Add("parameters",$fileHashTableParam)

$filePath = Save-File -initialDirectory $fileDir -initialFileName $fileName

$fileHashTable | ConvertTo-Json -Depth 5 | Out-File $filePath