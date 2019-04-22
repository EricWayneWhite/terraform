Terraform Workspaces
====================
This example uses the [terraform workspace](https://www.terraform.io/docs/state/workspaces.html) name to populate values for the AWS region and environment.  An S3 bucket will be created in the provided region with the environment value in the bucket name and tag.

The backend.tf.sample file can be renamed to backend.tf and configured with your own values to the use the [Hashicorp Terraform Enterprise Free Tier](https://app.terraform.io/app) to store the state.

You can use the [terraform workspace command](https://www.terraform.io/docs/commands/workspace/index.html) to manage workspaces.  For example:
```
# Create a dev and prod workspace for US-WEST-2
terraform workspace new dev_us-west-2
terraform workspace new prod_us-west-2

# List the workspaces
terraform workspace list

# Show that prod is currently selected
terraform workspace show

# Switch back to dev
terraform workspace select dev_us-west-2
```

If running the code without named workspaces (default workspace) the variable values will be taken from the variables.tf file.

<!--Start-->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_profile | The name of the AWS profile to use | string | `"default"` | no |
| aws\_region | AWS region name | string | `"us-east-1"` | no |
| environment | Environment name | string | `"none"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | S3 Bucket name |

<!--End-->
