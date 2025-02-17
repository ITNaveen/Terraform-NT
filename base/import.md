This way i can import current infra to terraform.
There may be resource created manually using console or ansible, so we want these resources to be controlled by terraform.

terraform import <resource_type>.<resource.name> <attribute>
terraform import aws_instance.webserver-2 i-0907080ub67v7t6897

Doing this wouldnt make our main.tf updated.

1. resource "aws_instance" "webserver-2" {
   }
   This is like saying "Hey Terraform, we want to manage this resource" without specifying any details yet

2. terraform import aws_instance.webserver-2 i-0907080ub67v7t6897 
   This adds the resource to Terraform's state file (terraform.tfstate) but doesn't update main.tf

3. terraform show | grep webserver-2 -A 50
   The output shows all resource attributes - copy the relevant ones to main.tf. This helps you build the proper configuration.

4. terraform plan 
   If your main.tf matches the actual resource state, you should see "No changes". If not, adjust your configuration.

5. terraform apply -refresh-only
   It's like doing a "health check" on just your Terraform-managed resources. It completely ignores any resources that were created manually outside of Terraform, even if they're in the same environment.


