terraform fmt - to format config files in canonical format

terraform validate - to validate config file, it there is an issue then terraform shows line and the file that is causing issue.

terraform show - it show current state of infra as seen by terraform.

terraform providers - to see all the used providers.
we can copy these providers to another dir using mirror command - 
terraform providers mirror  /root/terraform/new-project-dir

terrform output - to print all the output from config file
to pick specific output and not all - terraform output pet-name (it will show only pet-name output)

terraform plan - to sync terraform state file with real infra. This only modify state file and not the actual infra.

terraform graph - to see all depenency of resources.
first install graphwiz then this command will show clear visiuallization. 
then use - 
terraform graph | dot -Tsvg > graph.svg
graph.svg in the browser and see this graph.

............................................





