# Terraform Learning Project by AxyRes


## Getting Started

Before you begin, make sure you have the following prerequisites:

- [Terraform](https://www.terraform.io/) installed on your local machine.
- An AWS account and valid AWS Access Key ID and Secret Access Key.

## Project Structure

The project is organized into the following sections:

- `main.tf`: The main Terraform configuration file that defines the AWS resources you want to create.
- `variables.tf`: Configuration variables that can be customized.
- `outputs.tf`: Outputs that provide information about the created resources.
- `modules/`: Reusable Terraform modules that encapsulate specific functionalities.
## Usage
1. **Customize the Configuration**:
    - Edit some variables for all file `main.tf`, `variables.tf`, and `outputs.tf` to match your infrastructure requirements.
2. **Initialize Terraform**:
    - Go to Directory that have main.tf is the same level with this file README.md
    - Run the following command to initialize Terraform:
        ```sh
        terraform init
    - Review and Plan:
        ```sh 
        terraform plan
    - Apply Configuration:
        ```sh 
        terraform apply
    - Destroy Resources:
        ```sh 
        terraform destroy
## LICENSE

This project is licensed under the MIT License - see the LICENSE file for details.