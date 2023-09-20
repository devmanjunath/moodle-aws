# LMS Powered By AWS

## Project Overview
The AWS infrastructure automation project is a terraform-based automation solution for running Moodle ( LMS ) application behind ECS Fargate Containers. This will also help you create and deploy dependent resources and 

## Architecture
Image to be pasted here soon!!!

## Requirements
1. Docker
2. AWS-CLI
3. ECS-CLI ( Optional )
4. Terraform
5. Mkcert ( For Development Purposes )

## Pre-Requisites

## Running Your IAC Scripts

## List Of Resources Deployed
- Docker image for moodle
	- Including pushing the image to ECR
- Necessary IAM roles
- VPC
	- Public Subnets
	- Internet Gateway
	- Custom Routes
	- Security Groups
- Load Balancer
- EFS - Max I/O
- RDS - Aurora Mysql 8.0 ( Serverless )
- Elastic-Cache - Memcached
- ECS - Fargate
- ACM
- Route 53