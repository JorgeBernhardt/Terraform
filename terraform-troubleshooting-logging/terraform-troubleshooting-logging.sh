export TF_LOG="TRACE"
export TF_LOG_PATH=./logs/terraform_TRACE.log

export TF_LOG_CORE=ERROR
export TF_LOG_PROVIDER=TRACE

echo "export TF_LOG=TRACE" >> .bashrc
echo "export TF_LOG_PATH=./logs/terraform_TRACE.log" >> .bashrc

unset TF_LOG