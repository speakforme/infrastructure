# We use 2 dynamoDB tables
# one for sent-email counters
resource "aws_dynamodb_table" "email-counters" {
  name           = "email-counters"
  read_capacity  = 5
  write_capacity = 1

  hash_key = "email"

  attribute {
    name = "email"
    type = "S"
  }

  tags = {
    Name      = "email-counters"
    terraform = "true"
  }

  server_side_encryption {
    enabled = true
  }
}

# and another one for subscriptions
resource "aws_dynamodb_table" "email-subscriptions" {
  name           = "email-subscriptions"
  read_capacity  = 1
  write_capacity = 1

  hash_key = "uuid"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "email"
    write_capacity  = 10
    read_capacity   = 10
    projection_type = "KEYS_ONLY"
  }

  tags = {
    Name      = "email-subscriptions"
    terraform = "true"
  }

  server_side_encryption {
    enabled = true
  }
}
