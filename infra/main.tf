//---------------------------------------------------------------
//------------------------Lambda Funciton------------------------
//---------------------------------------------------------------

locals {
  resources_name = jsondecode(file("${path.module}/resources_name.json"))
}

resource "aws_lambda_function" "my_func_counter" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name    = local.resources_name.aws_lambda_function
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "func.lambda_handler"
  runtime          = "python3.9"
}
#
resource "aws_iam_role" "iam_for_lambda" {
  name               = local.resources_name.aws_iam_role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {
  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for connection of DB and lambda funciton"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:UpdateItem",
            "dynamodb:PutItem",

            "logs:CreateLogGroup",
            "logs:PutLogEvents",
            "logs:CreateLogStream",

            "s3:ListBucket",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:GetObject",

            "CloudWatch: PutMetricAlarm"
          ],
          "Resource" : "arn:aws:dynamodb:*:*:table/${local.resources_name.aws_dynamodb_table_1}"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda/packedlambda.zip"
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.my_func_counter.function_name
  authorization_type = "NONE"


  cors {
    allow_credentials = true
    allow_origins     = [local.resources_name.function_url_allow_origins.first, local.resources_name.function_url_allow_origins.second]

    allow_methods  = ["POST"]
    allow_headers  = ["Content-Type"]
    expose_headers = []

    max_age = 43200
  }
}




//---------------------------------------------------------------
//------------------------s3 Bucket------------------------------
//---------------------------------------------------------------

/*List for s3: 
1) Get the bucket policy from cloudfront and attach to s3 to only allow cloudfront to read s3
3) Upload the object files
4) Adjust the cicd bucket name to the name I have
*/

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket        = local.resources_name.aws_s3_bucket
  force_destroy = false
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls_for_s3" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Amazon S3 is automatically set "block public access" to true in default
# resource "aws_s3_bucket_public_access_block" "public_access_for_s3" {
#   bucket                  = aws_s3_bucket.my-s3-bucket.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# ACL conflicts the s3 policy, we want policy to take total control 
# resource "aws_s3_bucket_acl" "bucket_acl_for_s3" {
#   depends_on = [aws_s3_bucket_ownership_controls.ownership_controls_for_s3,
#   aws_s3_bucket_public_access_block.public_access_for_s3]


#   bucket = aws_s3_bucket.my-s3-bucket.id
#   access_control_policy {
#     grant {
#       grantee {
#         id   = data.aws_canonical_user_id.current.id
#         type = "CanonicalUser"
#       }
#       permission = "FULL_CONTROL"
#     }
#     owner {
#       id = data.aws_canonical_user_id.current.id
#     }
#   }
# }



resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_configuration_for_s3" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    bucket_key_enabled = true
  }
}

# No need to use static webstie, because we have cloudfront to access the objects. Set a root object in cloudfront
# resource "aws_s3_bucket_website_configuration" "hosting_website_for_s3" {
#   bucket = aws_s3_bucket.my-s3-bucket.id
#   index_document {
#     suffix = "resume.html"
#   }

#   error_document {
#     key = "404.html"
#   }
# }


resource "aws_s3_bucket_policy" "policy_for_s3" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Id" : "PolicyForCloudFrontPrivateContent",
      "Statement" : [
        {
          "Sid" : "AllowCloudFrontServicePrincipal",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudfront.amazonaws.com"
          },
          "Action" : "s3:GetObject",
          "Resource" : "${aws_s3_bucket.my-s3-bucket.arn}/*",
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceArn" : "${aws_cloudfront_distribution.aws_cloudfront_distribution_for_s3.arn}"
            }
          }
        }
      ]
    }
  )

}


//---------------------------------------------------------------
//------------------------SSL Cerficate---------------------------
//---------------------------------------------------------------

resource "aws_acm_certificate" "SSL_certificate_for_cloudfront_resume" {
  domain_name = local.resources_name.aws_acm_domain_name

  subject_alternative_names = [local.resources_name.aws_acm_alternative_names]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}



//---------------------------------------------------------------
//------------------------Cloudfront-----------------------------
//---------------------------------------------------------------
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = aws_s3_bucket.my-s3-bucket.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "cache_policy_for_resume_cloudfront" {
  name    = "cache_policy_for_resume_cloudfront"
  comment = "Optimized cache policy for Markdown posts"

  # TTL settings
  default_ttl = 86400    # 1 day
  max_ttl     = 31536000 # 1 year
  min_ttl     = 86400    # 1 minute

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }

}


resource "aws_cloudfront_distribution" "aws_cloudfront_distribution_for_s3" {
  origin {
    domain_name              = aws_s3_bucket.my-s3-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = "cloudfront_for_s3"
  }

  aliases         = [local.resources_name.aws_acm_domain_name, local.resources_name.aws_acm_alternative_names]
  enabled         = true
  is_ipv6_enabled = true

  # Don't need for hugo, we're using lambdaEdge to redirect index.html in subfolder
  # default_root_object = "index.html"

  price_class = "PriceClass_100"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = aws_cloudfront_cache_policy.cache_policy_for_resume_cloudfront.id
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "cloudfront_for_s3"
    compress               = true

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = aws_lambda_function.cloudfront_lambdaEdge_function.qualified_arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.SSL_certificate_for_cloudfront_resume.arn

    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


}





//---------------------------------------------------------------
//------------------------DynamoDB-------------------------------
//---------------------------------------------------------------

resource "aws_dynamodb_table" "dynamodb_table_for_resume" {
  name         = local.resources_name.aws_dynamodb_table_1
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}


# Don't create, otherwise any change in db value will trigger terraform to override
# # Craete an item, its id = "1", and has an attribute "views" set to be 1
# resource "aws_dynamodb_table_item" "dynamodb_table_item_for_resume" {
#   table_name = aws_dynamodb_table.dynamodb_table_for_resume.name
#   hash_key   = aws_dynamodb_table.dynamodb_table_for_resume.hash_key

#   item = <<ITEM
#   {
#     "id" : {"S" : "1"},
#     "views" : {"N" : "1"}
#   }
#   ITEM
# }





//---------------------------------------------------------------
//------------------------CloudWatch-----------------------------
//---------------------------------------------------------------

# Alarm for billing
resource "aws_cloudwatch_metric_alarm" "alarm_for_billing" {
  alarm_name          = "resume_challenge_alarm"
  metric_name         = "read_metric_for_resume"
  evaluation_periods  = 5
  namespace           = "AWS/DynamoDB"
  statistic           = "Sum"
  period              = 60
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 125
  datapoints_to_alarm = "3"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.sns_alarm_for_resume.arn]
}

resource "aws_sns_topic" "sns_alarm_for_resume" {
  name = "sns_alarm_for_resume"
}

resource "aws_sns_topic_subscription" "email_update_subscription" {
  topic_arn = aws_sns_topic.sns_alarm_for_resume.arn
  protocol  = "email"
  endpoint  = local.resources_name.my_email
}








//---------------------------------------------------------------
//------------------------Lambda Edge----------------------------
//---------------------------------------------------------------
resource "aws_iam_role" "cloudfront_lambdaEdge_role" {
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

data "archive_file" "zip_lambda_edge" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_edge/"
  output_path = "${path.module}/lambda_edge/packedlambda.zip"
}

resource "aws_lambda_function" "cloudfront_lambdaEdge_function" {
  filename         = data.archive_file.zip_lambda_edge.output_path
  source_code_hash = data.archive_file.zip_lambda_edge.output_base64sha256
  function_name    = local.resources_name.cloudfront_lambdaEdge_function
  role             = aws_iam_role.cloudfront_lambdaEdge_role.arn
  handler          = "func.lambda_handler"
  runtime          = "nodejs18.x"
  publish          = true
  provider         = aws.us_east_1
}


resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.cloudfront_lambdaEdge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}




//---------------------------------------------------------------
//------------------------Identity Provider----------------------
//---------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "openid_connect_provider_github_for_resume" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "1b511abead59c6ce207077c0bf0e0043b1382612"
  ]
}


resource "aws_iam_role" "github_cicd_for_resume" {
  name = "github-cicd"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.openid_connect_provider_github_for_resume.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${local.resources_name.github_account}/*"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "github_cicd_for_resume_policy" {
  role       = aws_iam_role.github_cicd_for_resume.id
  policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}
