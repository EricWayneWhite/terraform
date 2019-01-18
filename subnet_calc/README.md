Subnet Calculation
==================

This example will calculate subnets based on provided CIDR blocks.

The structure is based on the following configuration:
* A primary and secondary VPC with with a CIDR block each
* Three Availability Zones in each VPC
* Dividing the CIDR block into four initial subnets
* The first three subnets will be assigned as private, one per AZ
* The fourth block is broken up into four subnets again
* The first three of the smaller blocks will be assigned as public, one per AZ
* The last small block is left as a spare

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidr\_primary | - | string | `10.0.0.0/22` | no |
| cidr\_secondary | - | string | `10.1.0.0/22` | no |

## Outputs

| Name | Description |
|------|-------------|
| cidr\_primary | This is the CIDR block provided for the primary VPC |
| cidr\_secondary | This is the CIDR block provided for the secondary VPC |
| private\_subnets\_primary | This returns a list of private subnets for the primary VPC |
| private\_subnets\_secondary | This returns a list of private subnets for the secondary VPC |
| public\_subnets\_primary | This returns a list of public subnets for the primary VPC |
| public\_subnets\_secondary | This returns a list of public subnets for the secondary VPC |
| spare\_primary\_cidr | This is the spare subnet for the primary VPC |
| spare\_secondary\_cidr | This is the spare subnet for the secondary VPC |
