output "lambda_function_arn" {
    value = "${aws_lambda_function.foo.arn}"
}

output "lambda_function_full_arn" {
	value = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.foo.arn}/invocations"
}
