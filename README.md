### Prerequisites

- AWS account with appropriate permissions
- Terraform installed locally

# Overview

The project is organized into modules for each component of the architecture, such as ALB, ASG, NAT Gateway, RDS, Route 53, Security Groups, and VPC. Each module contains the necessary Terraform configuration files (`main.tf`, `vars.tf`, `outputs.tf`) for provisioning the respective resources.

The `root` directory contains the main Terraform configuration files (`main.tf`, `providers.tf`, `terraform.tf`, `terraform.tfvars`, `vars.tf`) for defining the overall infrastructure, including the VPC setup, subnet configurations, and the association of resources from the modules.

### Modules Overview

#### ALB (Application Load Balancer)

The ALB module configures an Application Load Balancer to distribute incoming traffic across multiple targets, such as EC2 instances in the ASG. It allows for high availability and scalability by automatically adjusting the traffic distribution based on the target's health checks. The ALB is configured with listeners to handle different protocols and port numbers, ensuring that traffic is routed correctly to the application.

#### ASG (Auto Scaling Group)

The ASG module sets up an Auto Scaling Group to manage a group of EC2 instances, ensuring that the desired number of instances is running to handle the application's load. The ASG uses launch configurations or launch templates to define the instance type, AMI, and other configurations. It also integrates with the ALB and scales in or out based on metrics such as CPU utilization, ensuring that the application remains responsive under varying loads.

#### NAT Gateway

The NAT Gateway module provisions a NAT Gateway in a public subnet to allow instances in private subnets to access the internet for software updates, package downloads, and other purposes. The NAT Gateway acts as a gateway for outbound traffic from the private subnet, ensuring that the instances remain private and secure from inbound internet traffic.

#### RDS (Relational Database Service)

The RDS module sets up a managed database service using Amazon RDS, which provides scalable and reliable database instances for storing application data. The module allows you to configure the database engine, instance class, storage type, and other parameters. It also handles database backups, maintenance, and monitoring, simplifying the management of the database infrastructure.

#### Route 53

The Route 53 module manages DNS records for the application, allowing you to define custom domain names and route traffic to the ALB or other services. It supports various routing policies, such as simple, weighted, and failover routing, to optimize traffic distribution and improve the application's availability and performance.

#### Security Groups

The Security Groups module defines security group rules to control inbound and outbound traffic to the instances and resources in the VPC. It allows you to specify the source and destination IP addresses, ports, and protocols for traffic, ensuring that only authorized traffic is allowed and enhancing the network security of the infrastructure.

#### VPC (Virtual Private Cloud)

The VPC module sets up a Virtual Private Cloud to isolate the application's network environment from other networks. It allows you to define the IP address range, subnets, route tables, and internet gateway for the VPC, providing a secure and scalable network infrastructure for the application.

### Setup

1. Clone the repository.
2. Navigate to the root directory.
3. Run `terraform init` to initialize the project.
4. Run `terraform plan` to review the execution plan.
5. Run `terraform apply` to apply the changes and create the infrastructure.
6. After deployment, you can access the application using the ALB's DNS name.

### Customization

- Modify the `terraform.tfvars` file to customize variables such as instance types, database settings, and VPC configurations.
- Update the modules' `.tf` files to adjust specific configurations based on your requirements.

### Maintenance

- Use `terraform plan` and `terraform apply` to manage and update the infrastructure.
- Regularly review and update security group rules, especially for public-facing services like the ALB.

### Destroy

- When no longer needed, use `terraform destroy` to tear down the infrastructure and avoid unnecessary charges.

### Conclusion

This Terraform project simplifies the deployment and management of a 2-tier architecture on AWS, providing scalability, high availability, and security for your applications.
