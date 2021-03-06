resource "aws_api_gateway_rest_api" "Oak9SampleAPIGateway" {
  name        = var.apiGatewayName
  description = "API Gateway invoking Oak9SampleFunction lambda function"
}


resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   parent_id   = aws_api_gateway_rest_api.Oak9SampleAPIGateway.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Oak9SampleFunction.invoke_arn
}

resource "aws_api_gateway_deployment" "Oak9SampleAPIGateway_deployment" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   stage_name  = var.apiGatewayStage
}