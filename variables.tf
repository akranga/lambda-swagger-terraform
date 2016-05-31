variable "stack_name" {}

variable "function_name" {}

variable "source_files" {
	default = "./*.js"
}

variable "runtime" {
	default = "nodejs4.3"
}

variable "timeout" {
	default = "300"
}

variable "memory_size" {
	default = "256"
}

variable "lambda_handler" {
	default = "lambda.handler"
}

variable "subnet_ids" {
	default = ""
}

variable "security_group_ids" {
	default = ""
}

variable "iam_role_arn" {}

variable "iam_role_id" {}

variable "aws_region" {
	default = "eu-west-1"
}

variable "lambda_exec_policy" {
	default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [ "arn:aws:logs:*:*:*" ]
        },
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:CreateNetworkInterface",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "autoscaling:CompleteLifecycleAction",
                "lambda:InvokeFunction"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [ "arn:aws:s3:::*" ]
        }
    ]
}
EOF
}

variable "rest_api_id" {}

variable "http_method" {
	default = "GET"
}

variable "stage_name"  {
	default = ""
}

variable "custom_swagger_template" {
    default = ""
}

variable "lambda_path" {}