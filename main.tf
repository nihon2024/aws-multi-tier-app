# main.tf

# Generate a random suffix for unique resource names if needed later
resource "random_id" "suffix" {
  byte_length = 4
}
