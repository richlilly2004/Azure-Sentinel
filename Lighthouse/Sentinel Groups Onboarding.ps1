##Client Name
$clientname = Read-Host -Prompt 'Input Client name'

Connect-AzureAD

##Create SentinelaaS group - Contributors
$sentinelcontributors = New-AzureADGroup -DisplayName "SentinelaaS - $clientname Contributors" -Description "AAD group created automatically SentinelaaS" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
##Create SentinelaaS group - Responders
$sentinelresponders = New-AzureADGroup -DisplayName "SentinelaaS - $clientname Responders" -Description "AAD group created automatically SentinelaaS" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
##Create SentinelaaS group - Readers
$sentinelreaders = New-AzureADGroup -DisplayName "SentinelaaS - $clientname Readers" -Description "AAD group created automatically SentinelaaS" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"