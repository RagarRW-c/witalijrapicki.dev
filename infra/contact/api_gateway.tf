resource "aws_api_gateway_rest_api" "contact_api" {
  name = "contact-form-api"
}

resource "aws_api_gateway_resource" "contact" {
  rest_api_id = aws_api_gateway_rest_api.contact_api.id
  parent_id   = aws_api_gateway_rest_api.contact_api.root_resource_id
  path_part   = "contact"
}

resource "aws_api_gateway_method" "post_contact" {
  rest_api_id   = aws_api_gateway_rest_api.contact_api.id
  resource_id   = aws_api_gateway_resource.contact.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_contact" {
  rest_api_id             = aws_api_gateway_rest_api.contact_api.id
  resource_id             = aws_api_gateway_resource.contact.id
  http_method             = aws_api_gateway_method.post_contact.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.contact.invoke_arn
}

resource "aws_api_gateway_method" "options_contact" {
  rest_api_id   = aws_api_gateway_rest_api.contact_api.id
  resource_id   = aws_api_gateway_resource.contact.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_contact" {
  rest_api_id = aws_api_gateway_rest_api.contact_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.options_contact.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.contact_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.options_contact.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.contact_api.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.options_contact.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://witalijrapicki.cloud'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

#deploy
resource "aws_api_gateway_deployment" "contact" {
  rest_api_id = aws_api_gateway_rest_api.contact_api.id

  depends_on = [
    aws_api_gateway_integration.post_contact,
    aws_api_gateway_integration.options_contact
  ]
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.contact_api.id
  deployment_id = aws_api_gateway_deployment.contact.id
}

#lambda function
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.contact_api.execution_arn}/*/*"
}

resource "aws_api_gateway_gateway_response" "default_4xx" {
  rest_api_id   = aws_api_gateway_rest_api.contact_api.id
  response_type = "DEFAULT_4XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'https://witalijrapicki.cloud'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

resource "aws_api_gateway_gateway_response" "default_5xx" {
  rest_api_id   = aws_api_gateway_rest_api.contact_api.id
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'https://witalijrapicki.cloud'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}
