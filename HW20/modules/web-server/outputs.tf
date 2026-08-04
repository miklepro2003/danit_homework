output "public_ip" {
  value = aws_instance.ec2public.public_ip  # выводим ip для prod
}
