#Import into Azure Automation
#Create variables for Sentinel_CustomerID, Sentinel_SharedKey, TenantID, AAD Account
#Import Azure AD and OMSIngestionAPI from the Modules Gallery
#Setup a recurrance schedule at least once a day

#Required Variables
$CustomerID = Get-AutomationVariable -Name 'Sentinel_CustomerID'
$SharedKey = Get-AutomationVariable -Name 'Sentinel_SharedKey'
$userlogType = 'AADUsers'
$devicelogType = 'AADDevices'
$TenantID = Get-AutomationVariable -Name 'TenantID'
$MyCredential = Get-AutomationPSCredential -Name 'AAD Account'

#Connect to Azure AD
Connect-AzureAD -TenantId $TenantID -Credential $MyCredential

#Collecting devices from AzureAD
$DevicesCollected = Get-AzureADDevice -All $True

# Ingesting data all at the same time
$JSONDevice = ConvertTo-Json $DevicesCollected -Compress -ErrorAction Stop 
$TimeStampfield = Get-date
Send-OMSAPIIngestionFile -customerId $customerId -sharedKey $sharedKey -body $JSONDevice -logType $devicelogType -TimeStampField $Timestampfield -Verbose