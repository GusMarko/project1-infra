resource "aws_dynamodb_table" "artists" {
  name         = "project1-artists-${var.env}"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "DataId"
    type = "S"
  }

  hash_key = "DataId"
}


resource "aws_ecr_repository" "code_images" {
  name = "project1/${var.env}/code-images"
}

resource "aws_ecr_repository_policy" "code_images" {
  repository = aws_ecr_repository.code_images.name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "songs" {
  bucket = "project1-songs-${var.env}"
}

resource "aws_s3_bucket_policy" "songs" {
  bucket = aws_s3_bucket.songs.id
  policy = data.aws_iam_policy_document.songs.json
}

data "aws_iam_policy_document" "songs" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::381492201388:user/mg-admin"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.songs.arn,
      "${aws_s3_bucket.songs.arn}/*",
    ]
  }
}
