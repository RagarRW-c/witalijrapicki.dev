output "contact_api_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/contact"
}