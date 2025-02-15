IAM basics - 

USER - 
lucy -then we have 2 kinds of access - 
1. programatic - using cli with access key id and secret access key.
2. aws console access - username and password.
console pasword - autogernated with power to change itself.
next - permission - next - review - create user.
you get access key and secret access keys.

Now user is created - click on username - you see password change policy there.
Add another policy - attached existing policy - admin access.

Create another user abdul - both access - add him in a group 
create a group with aws ec2 full access - then add tags - name: project sephare user, download access key

add lee and add him to previous group.
both abdul and lee are in this group and have ec2 access lets add s3 access for this group.

# policy - 
lets create ec2 read only policy - 
select a service - ec2
action permitted - read and list
which resource it applies on - all resources 
review - name - ec2_read_list.

# roles - 
A user can assume a role when needed, instead of having permanent access.
Example: A developer temporarily needs admin access for debugging.

role used for user if user need temp permission or roles are normally used for one aws service to access another with limitations.


# commands - 
1. list user - aws iam list-users
2. add user - aws iam create-user --user-name username
3. to see access keys and secret access - 
cat /root/.aws/credentials 
4. to attach policy to user - 
aws iam attach-user-policy --user-name naveen --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

...............................................
# IAM with Terraform - 
1. To create IAM user - 
   resource "aws_iam_user" "admin-user"  {
    name = "lucy"
    tags =  {
        description = "Technical team lead"
    }
}

# aws credentials for terraform - 
To save creds of AWS, its better to save them in computer under /home/user/.aws/credentials 
[default]
aws_access_key_id
aws_secret_access_key

ex -
[default]
aws_access_key_id=AKIAEXAMPLE123
aws_secret_access_key=abc123XYZexample456
region=us-east-1

[profile dev]
aws_access_key_id=AKIADEV123
aws_secret_access_key=devSecretKey789
region=us-west-2

to use specific one for terraform apply - 
set profile on providers.tf - 

provider "aws" {
  profile = "dev"   # Uses the dev profile from ~/.aws/credentials
  region  = "us-west-2"
}

or 
export AWS_PROFILE=dev
terraform apply

# temp way - 
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
...........................................

# attach IAM policies to user - 
so we have user - 
To create IAM user - 
   resource "aws_iam_user" "admin-user"  {
    name = "lucy"
    tags =  {
        description = "Technical team lead"
    }
}

....first lets create IAM policy - 
resource "aws_iam_policy" "adminuser" {
    name = AdminUsers
    policy =  << EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

...now attach this policy to user - 
resource "aws_iam_user_policy_attachment" "lucy-admin-access" {
    user = aws_iam_user.admin-user.name
    policy_arn = aws_iam_policy.adminuser.arn
}
................................................
................................................

Or we can make policy as file and save in the main dir - 

admin-policy.json 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}

resource "aws_iam_user" "admin-user"  {
    name = "lucy"
    tags =  {
        description = "Technical team lead"
    }
}

create IAM policy - 
resource "aws_iam_policy" "adminuser" {
    name = AdminUsers
    policy = file("admin-policy.json")
}

...now attach this policy to user - 
resource "aws_iam_user_policy_attachment" "lucy-admin-access" {
    user = aws_iam_user.admin-user.name
    policy_arn = aws_iam_policy.adminuser.arn
}

