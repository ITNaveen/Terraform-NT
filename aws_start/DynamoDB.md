No Sql db, it can scale easily for web, mobile apps like games, fully managed service.

data is replicated across multiple aws regions. it store data as key:value pairs or document.
ex - 
menu    model   year    vin
toyota  corolla 2004    79u9nu9u9
honda   civic   2017    79ujuuihii

here each row is an item and each item is composed with 1 or more attributes (year, menu etc).

to differentiate each item dynamo db use PRIMARY_KEY such as VIN and its always unique.

..........................
# create on aws console - 
On DynamoDB - create_table - table_name and primary_key
                                        |
                                    Create - once its created then you seen table name on left.

Go to item_tag and create item and then you see employee_id already populated as its our primary key.
then click + mark and add like name, age etc attributes, add more iteams then may be add role for each of them like developer, team-lead etc.
once all this done then use filter based on like role and you get entries based on the used filter.

......................................
......................................
# Create DynamoDB with terraform - 
resource "aws_dynamodb_table" "cars" {
  name         = "CarsTable"
  billing_mode = "PAY_PER_REQUEST"  # On-demand pricing (scalable)
  hash_key = "vin"  # Primary key (Partition Key)
  attribute {
    name = "vin"
    type = "S"  # String type
  }
}

Then create an item for this - 

resource "aws_dynamodb_table_item" "car_item" {
  table_name = aws_dynamodb_table.cars.name  # Reference the table
  hash_key   = "vin"
  item = <<EOF
{
  "vin": {"S": "79u9nu9u9"},
  "menu": {"S": "toyota"},
  "model": {"S": "corolla"},
  "year": {"N": "2004"}
}
EOF
}

This way we created then added item in dynamodb table.



