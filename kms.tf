resource "aws_kms_key" "this" {
  count = var.create_kms ? 1 : 0

  description             = "KMS key for CRL S3 bucket"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.kms[count.index].json
  enable_key_rotation     = var.enable_key_rotation
}

resource "aws_kms_alias" "this" {
  count = var.create_kms ? 1 : 0

  name          = format("alias/%s", var.kms_key_alias)
  target_key_id = aws_kms_key.this[count.index].key_id
}



