Lambda Demo Labs
================
This is a project based on the [A Cloud Guru](https://acloud.guru/) AWS Lambda course where I have recreated all of the items using Terraform.  Running the Terraform will create all the resources for all three labs.  Read the descriptions below for details on each lab.


Lab1
----
Lab1 Creates a NodeJS Lambda function that is triggered when a csv file is uploaded to the S3 bucket.  There are two scripts in two different zip files.  Setting the value of the variable "script_version" will switch the Lambda function between them, publishing new versions on an applied change.

To see the output of the Lambda, save the data below as to a file named "sample.csv".  Next, either use the console to upload the file to S3 or run the cli command below, replacing the bucket name with your own bucket name.  Finally go to the related CloudWatch Log group stream and view the results after the file has been uploaded to S3.  Note that you'll need to delete any files you place in the S3 bucket before running terraform destroy.

sample.csv
```
Day,Customers,Gross,Expenses
2016-05-25,45,500,273
2016-05-26,90,9240,3947
2016-05-27,20,200,250
```

```bash
# AWS S3 copy file command
aws s3 cp sample.csv s3://your-bucket-name

# AWS S3 command to remove the file so you can destroy all the resources via Terraform
aws s3 rm s3://your-bucket-name/sample.csv
```

### Actions
* Create S3 bucket
* Create IAM role and policies
* Create the CloudWatch Log group
* Create the Lambda function as the first version
* Set permission for S3 to trigger Lambda
* Define the S3 event trigger
* Change the value of script_version variable to publish a new version
  * Default value is 'csv_read'
  * Second option is 'csv_sum'


Lab2
----
Lab2 Creates a NodeJS Lambda function that is triggered when data is added to a Kinesis Data Stream.

To test the function, use the following cli command and example code file, then check the results in the related CloudWatch Log group.

sample_records.json
```json
[
    {
        "PartitionKey": "A",
        "Data": "2016-05-26,90,9240,3947"
    },
    {
        "PartitionKey": "B",
        "Data": "2016-05-27,80,10389,2487"
    },
    {
        "PartitionKey": "C",
        "Data": "2016-05-28,102,1958,2498"
    },
    {
        "PartitionKey": "D",
        "Data": "2016-05-29,48,6853,1038"
    }
]
```

```bash
# Command to put example records into the Kinesis stream
aws kinesis put-records --stream-name <your-kinesis-stream-name> --records file://sample_records.json
```

### Actions
* Create Kinesis Data Stream
* Create IAM role and policies
* Create the CloudWatch Log group
* Create the Lambda function
* Set the Kinesis event source mapping trigger


Lab3
----
Lab3 Creates a NodeJS Lambda function that is triggered when a record is added to the DynamoDB table, then it writes values back to the record.

To trigger the function, use the following cli code and example file.  To check the results, you can run the second command, review the DynamoDB table in the AWS console, or check the CloudWatch Logs group.

sample_record.json
```json
{
    "txid": {"S": "abcxyz"},
    "costs": {"N": "20"},
    "gross": {"N": "50"}
}
```

```bash
# Command to write the values
aws dynamodb put-item --table-name <your_table_name> --item file://sample_record.json

# Command to get the record back after updated by Lambda
aws dynamodb get-item --table-name <your_table_name> --key '{"txid": {"S": "abcxyz"}}'
```

### Actions
* Create DynamoDB table
* Create IAM role and policies
* Create the CloudWatch Log group
* Create the Lambda function
* Set the DynamoDB event source mapping trigger


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_profile | Name of the AWS profile | string | n/a | yes |
| lab1\_bucket\_name | Name of the Lab1 S3 Bucket | string | n/a | yes |
| aws\_region | AWS region for initial provider | string | `"us-east-1"` | no |
| lab1\_lambda\_function\_name | Name of the Lambda function for Lab1 | string | `"lab1"` | no |
| lab1\_role\_cloudwatch\_policy\_name | Name of the IAM policy for Lab1 CloudWatch Logs access | string | `"lab1-cloudwatch"` | no |
| lab1\_role\_name | Name of the IAM role for Lab1 | string | `"lab1"` | no |
| lab1\_role\_s3\_policy\_name | Name of the IAM policy for Lab1 S3 access | string | `"lab1-s3-get-object"` | no |
| lab2\_kinesis\_stream\_name | Name of the Kinesis Data Stream for Lab2 | string | `"lab2-stream"` | no |
| lab2\_lambda\_function\_name | Name of the Lambda function for Lab2 | string | `"lab2"` | no |
| lab2\_role\_cloudwatch\_policy\_name | Name of the IAM policy for Lab2 CloudWatch Logs access | string | `"lab2-cloudwatch"` | no |
| lab2\_role\_kinesis\_policy\_name | Name of the IAM policy for Lab2 kinesis access | string | `"lab2-kinesis"` | no |
| lab2\_role\_name | Name of the IAM role for Lab2 | string | `"lab2"` | no |
| lab3\_dynamodb\_table\_name | Name of the DynamoDB table for Lab3 | string | `"lab3-dynamodb"` | no |
| lab3\_lambda\_function\_name | Name of the Lambda function for Lab3 | string | `"lab3"` | no |
| lab3\_role\_cloudwatch\_policy\_name | Name of the IAM policy for Lab3 CloudWatch Logs access | string | `"lab3-cloudwatch"` | no |
| lab3\_role\_dynamodb\_policy\_name | Name of the IAM policy for Lab3 DynamoDB access | string | `"lab3-dynamodb"` | no |
| lab3\_role\_name | Name of the IAM role for Lab3 | string | `"lab3"` | no |
| script\_version | This set the script to run.  Choose csv_read or csv_sum | string | `"csv_read"` | no |

## Outputs

| Name | Description |
|------|-------------|
| lab1\_lambda\_latest\_version | Version of the Lab1 lambda |
| lab1\_lambda\_script\_version | Version of the script run by the lambda |
