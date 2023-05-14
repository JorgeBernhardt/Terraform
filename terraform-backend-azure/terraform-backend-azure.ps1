$resourceGroupName = "RG-DEMO-TF"
$storageAccountName = "storageaccountdemostf"
$containerName = "terraform"

$storageAccount = Get-AzStorageAccount `
  -Name "$storageAccountName" `
  -ResourceGroupName $resourceGroupName

New-AzStorageContainer `
  -Name $containerName `
  -Context $storageAccount.Context `
  -Permission blob