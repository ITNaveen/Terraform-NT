# mutable and immutable update - 
Terraform generally follows an immutable infrastructure approach, but it's important to understand that it can support both patterns:
Immutable Infrastructure (Preferred Approach):

Resources are never modified in-place
When changes are needed, new resources are created and old ones are destroyed
This ensures consistency and reproducibility
Reduces configuration drift and "snowflake" servers.

......................................................................
# Lifycycle rule - 
normally terraform destroy old infra and then create new one but sometime we want it to create new then destroy old or not
destroy old one at all , i am talking about when we do update.

1. create new before destroying old - 
resource "local_file" "pet" {
  filename        = "/root/pets.txt"
  content         = "We love pets!"
  file_permission = "0700"

  lifecycle {
    create_before_destroy = true      #this way terraform destroy old one after creating new one
  }
}
2. to prevent destroying old one - 
resource "local_file" "pet" {
  filename        = "/root/pets.txt"
  content         = "We love pets!"
  file_permission = "0700"

  lifecycle {
    prevent_destroy = true      #this way terraform cant destroy old resource at all
  }
}

.......................................
# Ignore change - 
we can also intruct terraform not to touch some specifics in th resource with ignore change arguement.

resouces "aws_instance" "webserver" {
    ami= 697977023hihoo707
    instance_type= t2.micro
    tags= {
        Name = "ProjectA-Webserver"
    }
    lifecycle {
        ignore_changes = [
            tags               # This way i have stopped terraform to change tag name.
        ]
    }
}

......................
    lifecycle {
        ignore_changes = [
            tags, ami              # This way i have stopped terraform to change tag, ami.
        ]
    }

    lifecycle {
        ignore_changes = all       # no chnages for this resource                        
    }
........................