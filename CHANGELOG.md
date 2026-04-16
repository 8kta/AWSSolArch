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
