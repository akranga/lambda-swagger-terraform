resource "null_resource" "zip_payload" {

    provisioner "local-exec" {
        command = <<EOM
#!/bin/bash
mkdir -p ${path.cwd}/.terraform/${var.stack_name}/${var.function_name} | true
cp -f ${var.source_files} ${path.cwd}/.terraform/${var.stack_name}/${var.function_name} 
( cd ${path.cwd}/.terraform/${var.stack_name}/${var.function_name}/ && zip -r lambda-payload.zip . )
EOM
    }
}

resource "null_resource" "sleep" {
    provisioner "local-exec" {
        command = "sleep 10"
    }
}

resource "aws_lambda_function" "foo" {
    depends_on = ["null_resource.zip_payload",
                  "aws_iam_role_policy.lambda",
                  "null_resource.sleep"] # UnauthorizedOperation. EC2 Error Message: You are not authorized to perform this operation

	function_name = "${var.stack_name}_${var.function_name}"
	filename = "${path.cwd}/.terraform/${var.stack_name}/${var.function_name}/lambda-payload.zip"
    role = "${var.iam_role_arn}"
    runtime = "${var.runtime}"
    handler = "${var.lambda_handler}"
    memory_size = "${var.memory_size}"
    timeout = "${var.timeout}"
    vpc_config {
    	subnet_ids = ["${split(",", var.subnet_ids)}"]
    	security_group_ids = ["${split(",", var.security_group_ids)}"]
    }
}

resource "aws_iam_role_policy" "lambda" {
    name = "${var.stack_name}_${var.function_name}-policy"
    role = "${var.iam_role_id}"
    policy = "${var.lambda_exec_policy}"
}

resource "template_file" "swagger" {
    template = "${file( coalesce("${var.custom_swagger_template}", "${path.module}/default-swagger.yaml") )}"

    vars {
        stage_name = "${var.stage_name}"
        http_method = "${var.http_method}"
        aws_region = "${var.aws_region}"
        lambda_path = "${var.lambda_path}"
        lambda_function_full_arn = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.foo.arn}/invocations"
        stack_name = "${var.stack_name}"
    }

    provisioner "local-exec" {
        command = <<EOM
mkdir -p ${path.cwd}/.terraform/${var.stack_name} | true
cat > ${path.cwd}/.terraform/${var.stack_name}/swagger-${var.function_name}.yaml <<EOF
${self.rendered}
EOF
${path.module}/import-swagger.py ${var.rest_api_id} ${path.cwd}/.terraform/${var.stack_name}/swagger-${var.function_name}.yaml
EOM
    }
}

