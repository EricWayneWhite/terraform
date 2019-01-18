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
