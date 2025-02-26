# Progressive Terraform Exercises for AWS - Beginner to Expert

## Prerequisites
- AWS Account with appropriate permissions
- Terraform installed (version 1.0+)
- Basic understanding of AWS services
- AWS CLI configured with appropriate credentials

## Exercise Structure
Each exercise includes:
1. Objective
2. Requirements
3. Step-by-step guide
4. Solution
5. Additional challenges (where applicable)

## Beginner Level Exercises

### Exercise 1: First AWS Resource
**Objective:** Create your first EC2 instance using Terraform

**Requirements:**
- Create a basic EC2 instance
- Use the AWS provider
- Understand basic Terraform workflow

**Steps:**
1. Initialize Terraform project
2. Configure AWS provider
3. Define EC2 resource
4. Apply configuration

**Solution:**
```hcl
# main.tf
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "first_instance" {
  ami           = "ami-0735c191cf914754d"
  instance_type = "t2.micro"
  
  tags = {
    Name = "FirstInstance"
  }
}
```

### Exercise 2: Variables and Outputs
**Objective:** Learn to use variables and outputs

**Requirements:**
- Create EC2 instance using variables
- Output instance details
- Use different variable types

**Solution:**
```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# main.tf
resource "aws_instance" "second_instance" {
  ami           = "ami-0735c191cf914754d"
  instance_type = var.instance_type

  tags = {
    Name = "SecondInstance"
  }
}

# outputs.tf
output "instance_public_ip" {
  value = aws_instance.second_instance.public_ip
}
```

### Exercise 3: Resource Dependencies
**Objective:** Create multiple resources with dependencies

**Requirements:**
- Create VPC
- Create Subnet
- Launch EC2 in the subnet

**Solution:**
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "MainSubnet"
  }
}

resource "aws_instance" "dependent_instance" {
  ami           = "ami-0735c191cf914754d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
}
```

## Intermediate Level Exercises

### Exercise 4: Data Sources
**Objective:** Use data sources to query AWS resources

**Requirements:**
- Query latest Amazon Linux 2 AMI
- Create EC2 instance using the AMI
- Use data source for VPC information

**Solution:**
```hcl
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "data_instance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
}
```

### Exercise 5: Modules
**Objective:** Create and use a custom module

**Requirements:**
- Create a VPC module
- Include subnet creation
- Make module configurable
- Use the module in main configuration

**Solution:**
```hcl
# modules/vpc/main.tf
variable "vpc_cidr" {
  type = string
}

resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "module_subnet" {
  vpc_id     = aws_vpc.module_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)
}

output "subnet_id" {
  value = aws_subnet.module_subnet.id
}

# main.tf
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "172.16.0.0/16"
}
```

## Advanced Level Exercises

### Exercise 6: Remote State Management
**Objective:** Implement remote state with S3 and DynamoDB

**Requirements:**
- Configure S3 backend
- Enable state locking with DynamoDB
- Implement workspace-based environments

**Solution:**
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

# state-resources.tf
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### Exercise 7: Complex Infrastructure
**Objective:** Create a complete web application infrastructure

**Requirements:**
- VPC with public and private subnets
- Application Load Balancer
- Auto Scaling Group
- RDS instance
- Security Groups

**Solution:**
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "complete-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}

resource "aws_lb" "web" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_launch_template" "web" {
  name_prefix   = "web"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}
```

### Exercise 8: Custom Providers and Resources
**Objective:** Create custom provider and resource configurations

**Requirements:**
- Implement provider aliases
- Use multiple regions
- Create custom conditions and validations

**Solution:**
```hcl
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

resource "aws_instance" "east_instance" {
  provider = aws.us_east
  
  ami           = "ami-0735c191cf914754d"
  instance_type = "t2.micro"

  lifecycle {
    precondition {
      condition     = var.environment == "production"
      error_message = "East instance can only be created in production environment"
    }
  }
}
```

## Expert Level Exercises

### Exercise 9: Infrastructure Testing
**Objective:** Implement comprehensive testing

**Requirements:**
- Write Terratest tests
- Implement pre-commit hooks
- Create custom validation rules

**Solution:**
```go
// test/vpc_test.go
package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

func TestVPCCreation(t *testing.T) {
  terraformOptions := &terraform.Options{
    TerraformDir: "../",
    Vars: map[string]interface{}{
      "vpc_cidr": "172.16.0.0/16",
    },
  }

  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)

  vpcID := terraform.Output(t, terraformOptions, "vpc_id")
  assert.NotEmpty(t, vpcID)
}
```

### Exercise 10: Advanced State Management
**Objective:** Handle complex state scenarios

**Requirements:**
- Implement state migration
- Handle resource moves
- Manage state imports

**Solution:**
```hcl
# state migration
moved {
  from = aws_instance.old_name
  to   = aws_instance.new_name
}

# Import example
resource "aws_instance" "imported" {
  # Resource configuration that matches existing instance
  ami           = "ami-0735c191cf914754d"
  instance_type = "t2.micro"
}

# Run: terraform import aws_instance.imported i-1234567890abcdef0
```

[Exercises 11-20 continue with additional advanced topics including:]
- Infrastructure Patterns and Best Practices
- Security Implementations
- Cost Optimization
- Disaster Recovery
- Multi-Account Setup
- Cross-Region Deployments
- Service Mesh Integration
- Container Orchestration
- Serverless Architecture
- Infrastructure Monitoring

Each exercise builds upon previous knowledge while introducing new concepts. Complete solutions and variations are provided for all exercises.
