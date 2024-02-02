data "aws_availability_zones" "available" {}



data "aws_iam_policy_document" "ssm_document_permission_policy" {
  statement {
    actions = [
      "ssm:DescribeDocumentPermission"
    ]

    resources = [
      "arn:aws:ssm:eu-south-1:140634793718:document/dimitar-bastion-ssm"
    ]
  }
}
