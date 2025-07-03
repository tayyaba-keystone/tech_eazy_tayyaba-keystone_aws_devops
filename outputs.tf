#output block that show after applying 
output "instance_ip" {
  value = aws_instance.app_instance.public_ip
}