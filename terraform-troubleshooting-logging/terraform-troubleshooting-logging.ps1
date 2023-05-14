$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="./logs/terraform_TRACE.log"

$env:TF_LOG_CORE="ERROR"
$env:TF_LOG_PROVIDER="TRACE"

notepad $profile

$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="./logs/terraform_TRACE.log"

Remove-Item -Path env:TF_LOG