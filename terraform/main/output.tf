output "db_private_ip" {
  description = "db private IP"
  value       = aws_instance.database.*.private_ip
  sensitive   = true
}
