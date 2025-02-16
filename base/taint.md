resource "aws_instance" "webserver" {
  ami           = "ami-0edab43b6fa892279"
  instance_type = "t2.micro"

  # Log instance creation
  provisioner "local-exec" {
    on-failure = continue
    command = "echo Instance ${aws_instance.webserver.public_ip} Created on $(date) >> /tmp/instance_created.log"
  }
}
so In this case if "/tmp/instance_created.log" is not avaiable then resource creation will be failed and terraform will mark this 
resource TAINTED.

......................
......................
......................
Terraform Tainting: A Debugging Overview
What is Tainting?

A debugging mechanism in Terraform
Marks resources for complete replacement
Primarily used for troubleshooting infrastructure issues

...........Key Commands....................
Checking Tainted Resources -------
terraform show
terraform state list

Tainting a Resource - 
terraform taint resource_type.resource_name
terraform taint aws_instance.webserver

Removing a Taint --------
terraform untaint resource_type.resource_name
terraform untaint aws_instance.webserver

you need to check individually resources wheather they are tainted or not - terraform state show aws_my_ec2

...........When to Use Tainting................
Resource appears misconfigured
Provisioners failed during initial setup
Debugging complex infrastructure states
Forcing complete resource recreation

............Important Considerations..............
Destroys and recreates the entire resource
Can cause temporary infrastructure downtime
Loses any state not defined in configuration
Dependent resources may be affected