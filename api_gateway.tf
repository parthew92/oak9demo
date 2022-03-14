resource "aws_api_gateway_rest_api" "Oak9SampleAPIGateway" {
  # oak9: AuthType is not configured
  # oak9: AuthorizationType is not configured
  # oak9: aws_api_gateway_method.authorizer_id is not configured
  # oak9: aws_api_gateway_method.resource_id is not configured
  # oak9: aws_api_gateway_method.rest_api_id is not configured
  # oak9: aws_api_gateway_domain_name.mutual_tls_authentication is not configured
  # oak9: StageDescription.MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_method.http_method is not configured
  # oak9: MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_domain_name.certificate_arn is not configured
  # oak9: aws_api_gateway_domain_name.regional_certificate_arn is not configured
  aws_api_gateway_domain_name.security_policy = "TLS_1_2"
  # oak9: aws_api_gateway_rest_api.policy is not configured
  aws_api_gateway_usage_plan_key.key_type = "API_KEY"
  name        = var.apiGatewayName
  description = "API Gateway invoking Oak9SampleFunction lambda function"
}


resource "aws_api_gateway_resource" "proxy" {
  # oak9: AuthType is not configured
  # oak9: AuthorizationType is not configured
  # oak9: aws_api_gateway_method.authorizer_id is not configured
  # oak9: aws_api_gateway_method.resource_id is not configured
  # oak9: aws_api_gateway_domain_name.mutual_tls_authentication is not configured
  # oak9: StageDescription.MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_method.http_method is not configured
  # oak9: MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_domain_name.certificate_arn is not configured
  # oak9: aws_api_gateway_domain_name.regional_certificate_arn is not configured
  aws_api_gateway_domain_name.security_policy = "TLS_1_2"
  # oak9: aws_api_gateway_rest_api.policy is not configured
  aws_api_gateway_usage_plan_key.key_type = "API_KEY"
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   parent_id   = aws_api_gateway_rest_api.Oak9SampleAPIGateway.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  # oak9: AuthType is not configured
  # oak9: AuthorizationType is not configured
  # oak9: aws_api_gateway_method.authorizer_id is not configured
  # oak9: aws_api_gateway_domain_name.mutual_tls_authentication is not configured
  # oak9: StageDescription.MethodSettings.HttpMethod is not configured
  # oak9: MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_domain_name.certificate_arn is not configured
  # oak9: aws_api_gateway_domain_name.regional_certificate_arn is not configured
  aws_api_gateway_domain_name.security_policy = "TLS_1_2"
  # oak9: aws_api_gateway_rest_api.policy is not configured
  aws_api_gateway_usage_plan_key.key_type = "API_KEY"
   rest_api_id   = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  # oak9: AuthType is not configured
  # oak9: AuthorizationType is not configured
  # oak9: aws_api_gateway_method.authorizer_id is not configured
  # oak9: aws_api_gateway_domain_name.mutual_tls_authentication is not configured
  # oak9: StageDescription.MethodSettings.HttpMethod is not configured
  # oak9: MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_domain_name.certificate_arn is not configured
  # oak9: aws_api_gateway_domain_name.regional_certificate_arn is not configured
  aws_api_gateway_domain_name.security_policy = "TLS_1_2"
  # oak9: aws_api_gateway_rest_api.policy is not configured
  aws_api_gateway_usage_plan_key.key_type = "API_KEY"
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Oak9SampleFunction.invoke_arn
}

resource "aws_api_gateway_deployment" "Oak9SampleAPIGateway_deployment" {
  # oak9: AuthType is not configured
  # oak9: AuthorizationType is not configured
  # oak9: aws_api_gateway_method.authorizer_id is not configured
  # oak9: aws_api_gateway_method.resource_id is not configured
  # oak9: aws_api_gateway_domain_name.mutual_tls_authentication is not configured
  # oak9: StageDescription.MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_method.http_method is not configured
  # oak9: MethodSettings.HttpMethod is not configured
  # oak9: aws_api_gateway_domain_name.certificate_arn is not configured
  # oak9: aws_api_gateway_domain_name.regional_certificate_arn is not configured
  aws_api_gateway_domain_name.security_policy = "TLS_1_2"
  # oak9: aws_api_gateway_rest_api.policy is not configured
  aws_api_gateway_usage_plan_key.key_type = "API_KEY"
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   stage_name  = var.apiGatewayStage
}