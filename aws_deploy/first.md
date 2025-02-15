# terraform installation - 
curl -LO https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip

unzip terraform_1.8.5_linux_amd64.zip -d terraform_1.8.5
mv terraform_1.8.5/terraform /usr/local/bin/

# check which aws region is configured - 
cd .aws 
ls -la 
cat config

# workspaces - this includes provisioners 
provisioners to be used a last resort.
remote-exec is to execute script on remote on resource when its created.

- create new workspace - terraform workspace new test-workspace
- switch to existing workspace - terraform workspace select dev
- to show all workspaces - terraform workspace list

- use provisionars - 
resource "null_resource" "local_null_resource"  {
  provisioner "local-exec" {
    command = "echo 'Provisioning successful' > provisioner.txt"
  }
}

Inspect the terraform.tfstate file that has been created after you applied the Terraform configuration in the previous task. You won't find any mention about provisioner.txt in the state file.
This implies that the files created as part of the provisioner are not managed by Terraform. Provisioners are used to execute scripts or commands on the resources after they are created, but any files or configurations created by these scripts are not tracked by Terraform.

# automation, creating github repo - 
provider "github" {
   # taken = ""
}

resource "github_repository" "terraform-infra" {
    name = "terraform-infra"
    description = "new repo by terraform"
    visibility = "public"    
}

output "repository_clone_url_ssh" {
    value = github_repository.terraform-infra.ssh_clone_url
}

touch "github-repo_info.json"
{
    "REPO_OWNER": "ITNaveen",
    "ACCESS_TOKAN": ""
}

repository_clone_url_ssh = "git@github.com:ITNaveen/terraform-infra.git"
repo created 

- now in /root/.ssh/pub 
public key is created, so copy it and then github - setting - gpg and ssh keys - then add ssh keys - paste our public key there.

then git clone repo_address 

# on root we have a static-web-app dir with all code now i need to upload this as zip to my s3-bucket(already created) - 
- go to this folder (static-web-app) - zip ../app-v1.zip -r * .[^.]*
you will get zip file then .
- go to root - 
aws s3 cp app-v1.zip s3://terraform-web-app-bucket-4b45b3680dd2/

