# resource "aws_s3_bucket" "my_bucket" {
#   bucket = "ak-terraform-bucket" 
# }

resource "time_sleep" "name" {
  create_duration = "100s"
  destroy_duration = "100s"
}