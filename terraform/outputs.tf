output "public_ip" {
  value = aws_instance.mongo.public_ip
}

output "instance_id" {
  value = aws_instance.mongo.id
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_instance.mongo.public_ip}"
}

output "ssh_command2" {
  value = "ssh ubuntu@${aws_instance.mongo.public_ip} sudo tail -f /var/log/cloud*"
}
