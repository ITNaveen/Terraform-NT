This way i can import current infra to terraform.
There may be resource created manually using console or ansible, so we want these resources to be controlled by terraform.

terraform import <resource_type>.<resource.name> <attribute>
terraform import aws_instance.webserver-2 i-0907080ub67v7t6897

Doing this wouldnt make our main.tf updated.

1. we need to write a resource block without attributes like - 
   resource "aws_instance" "webserver-2" {
   }

2. now running this - terraform import aws_instance.webserver-2 i-0907080ub67v7t6897 
   This will then link this resource to terraform state.

3. terraform show
   this will show the current state of the imported resource, including all attributes.
   now add this resource completely to main.tf

4. terraform plan 
   to match infra with configuration.

5. terraform apply -refresh-only
   It's like doing a "health check" on just your Terraform-managed resources. It completely ignores any resources that were created manually outside of Terraform, even if they're in the same environment.


