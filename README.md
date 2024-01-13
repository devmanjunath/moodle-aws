# Terraform For Test-Drive

Hi! I'm your first Markdown file in **StackEdit**. If you want to learn about StackEdit, you can read me. If you want to play with Markdown, you can edit me. Once you have finished with me, you can create new files by opening the **file explorer** on the left corner of the navigation bar.

# Pre-Requisites

- Ubuntu ( Preferrably 22.04 )
- Docker
- AWS CLI
- Terraform
- Python 3.11
- Git
- Mkcert ( For self-signed certificates )

# Modules

1. Network ( VPC ), which also includes
   - 3 Public Subnets with Internet Gateway and a custom route attached
   - 3 Private Subnets with Nat Gateway with Elastic IP and custom route attached
   - 4 Security Groups for the following
     - Web ( 443 )
     - NFS ( 2049 )
     - MYSQL ( 3306 )
     - Redis ( 6379 )
2. ACM ( Amazon Certificate Manager )
3. Route 53 ( This will change to GoDaddy in the future )
4. Application Load Balancer, which also includes
   - Listeners
   - Record attachment to route53
   - Target Groups
5. SES ( Simple Email Service )
6. RDS with final snapshot
7. ElastiCache ( Redis )
8. EFS with Access Point
9. EC2 Auto Scaling ( Isolated from ECS )
10. ECR ( Elastic Container Registry )
11. ECS ( Elastic Container Service ), which also includes - Building images for the service - Cluster - Capacity Provider - Task Definition - Service - App Auto Scaling for the service - Event Bridge Triggers
    > Apart from the above modules, user will be needed to create a S3 bucket dedicated to terraform configuration. This is used for storing the state files and other meta data.

# Setting Up Terraform Project

## Get Source Code

1. Clone the terraform scripts from the github repository to local system
   ```console
   foo@user:~/Documents$ git clone https://github.com/devmanjunath/moodle-aws.git
   ```
2. Open the project on text editor. For Example: VS Code
3. Open the the terminal inside text editor and initialize the terraform scripts
   ```console
   foo@user:~/Documents/moodle-aws$ terraform init
   ```
   > The **init** command will initialize the entire terraform scripts and modules with the state files stored in S3 bucket. This setting can be found under [**backend.tf**](https://github.com/devmanjunath/moodle-aws/blob/main/backend.tf) in the root folder

## Execute Terraform Scripts

Before we run the terraform scripts, we need to setup the workspace for the project. This will help the user isolate their terraform resources for different environment

1. Switch the workspace to **mumbai**
   ```console
   foo@user:~/Documents/moodle-aws$ terraform workspace select mumbai
   ```
   > The terraform workspace **mumbai** has been already created for the user, so no need to create a new workspace
2. Duplicate the **mumbai.auto.tfvars_bak** file and rename the new file to **mumbai.auto.tfvars**
3. Now you can apply the terraform scripts
   ```console
   foo@user:~/Documents/moodle-aws$ terraform apply --auto-approve
   ```
4. This process might take some time for the following resources
   - ACM validation itself will take about 30 to 45 minutes based on the status of the Amazon certificate issued.
   - RDS will take a minimum of 4 to 7 minutes to get deployed
   - ETA for Building docker images might flactuate based on your network performance and would take about 5 to 10 minutes
   - Elasticache & NFS would also take 5 minutes respectively
   - Rest of the resources would be completed within <1 minute

## Destroy Cloud Resources

Make sure to destroy the cloud resources deployed via terraform to avoid incurring unwanted running costs on AWS

1. Switch the workspace to **mumbai**, if not already selected
   ```console
   foo@user:~/Documents/moodle-aws$ terraform workspace select mumbai
   ```
2. Now destroy the resources on cloud
   ```console
   foo@user:~/Documents/moodle-aws$ terraform destroy --target=module.network --auto-approve
   ```
3. This process would also take the same time as **apply**, depending upon the resources created on the AWS cloud.

# Default Environment Variables

Some of the default environment variables and values are already setup in the project. They can be changed and must be applied on the terraform configuration.

> Mind you that the **tfvars** file does not support JSON format. The below format is used for better user readability

```json
{
  "region": "ap-south-1",
  "project": "Test-Drive",
  "container_config": {
    "moodle": {
      "cpu": 2048,
      "memory": 4096,
      "name": "moodle",
      "portMappings": [
        {
          "containerPort": 443,
          "hostPort": 443
        },
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  },
  "environment": {
    "moodle": {
      "DB_TYPE": "mysqli",
      "HOST_NAME": "cloudbreathe.in",
      "ADMIN_USER": "user",
      "ADMIN_PASSWORD": "bitnami",
      "FULL_SITE_NAME": "Test Drive"
    }
  },
  "rds_config": {
    "instance_type": "db.m7g.large",
    "storage": 30
  },
  "ec2_config": {
    "image_id": "ami-0345c0581a1b3637a",
    "instance_type": "m5.large",
    "users": 300
  }
}
```
