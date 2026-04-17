# FBOMB: Feedback Optimized Model Base

## 1.0.0
    Deployment TBD
    Features: 
        - Goups
        - Policies
        - Users
        - .gitignore updated to remove all terraform
        - Run successfully in aws
        - Roles created. This is only one example of a role which has read only access to a secure S3 bucket
        - users created by this terraform project won't be able to run 'terraform apply' command. deny_terraform_apply_policy created and attached to the users for that
        - Fixed the error: 
            ```txt
            module.deny_terraform_apply_policy.aws_iam_policy.this: Creating...
            ╷
            │ Error: creating IAM Policy (awssolarch-deny-terraform-apply-dev): operation error IAM: CreatePolicy, https response error StatusCode: 400, RequestID: d1ee546a-31c0-465f-b971-b975aad84474, MalformedPolicyDocument: Action vendors (e.g., aws, ec2, etc.) must not contain wildcards.
            │ 
            │   with module.deny_terraform_apply_policy.aws_iam_policy.this,
            │   on ../modules/iam_policies/main.tf line 1, in resource "aws_iam_policy" "this":
            │    1: resource "aws_iam_policy" "this" {
            │ 
            ```
            i removed all the wildcards from the policy document refering to services.
            I better created a role which can be attached to the services to only allow terraform plan. and add -terraform-state-backend- policy for groups