When something gpes wrong then use debugging and logging is the best way, we have 5 types of logging.
1. INFO
2. WARNING
3. ERROR
4. DEBUG
5. TRACE

TRACE   : ████████████████████ (Most Detailed)
DEBUG   : ████████████ 
INFO    : ████████
WARNING : ███
ERROR   : █ (Least Detailed)


ERROR → Logs only critical errors
WARN → Logs warnings and errors
INFO → Logs general operational information
DEBUG → Logs detailed debugging information - execution step by step
TRACE → Logs extremely detailed internal debugging

# To use - 
# Set log type and path before Terraform commands
export TF_LOG=TRACE
export TF_LOG_PATH=/tmp/terraform.log

# Run Terraform commands in sequence
terraform init
terraform validate
terraform plan
terraform apply

# After all operations are complete, unset log path
unset TF_LOG_PATH

# Optional: Also unset log level if you want
unset TF_LOG

