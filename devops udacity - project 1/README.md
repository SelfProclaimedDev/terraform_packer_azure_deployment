# Deploying cluster of virtual machines with using loadbalancer and using packer as VM Image.

#Introduction

Used Terraform template to deploy cluster of VM's using loadbalancer. Used packer to deploy Ubuntu VM Image and using terraform to create cluster from that image. 


#Getting Started

1. Create Azure account
2. Download Azure CLI and install.
3. Create subscription in Azure account.

#Dependencies
1. Download terraform and packer.
2. Can put your terraform and packer exe file location in System Variables to access from anywere in your system.(For Windows User).
3. Create two App Registrations for Terraform and Packer in Azure Active Directory. Create client secrets in both apps. You can create secrets under Certificates & secrets.

#Instructions

1. README.md file present in azure policies. You can check it how to set policy in subscription level.
2. In Packer code folder packer json file is present. We can use it to create image in azure.
3. Enter your client_secret, client_id and subscription_id in variables section in packer file.
4. Use command "packer build projectpacker.json" to deploy image in intended resource group as mentioned inside file.
5. For Terraform enter your client_secret, client_id, tenant_id and subscription_id in terraform.tfvars file in terraform code directory.
6. In vars.tf files all variables are defined with description and user values are given in .tfvars file.
7. In .tfvars file numberofvm variable sets how many vm's you want in your cluster.
8. Run command "terraform init" to download packer files.
9. Then run "terraform plan -out solutions.plan" to plan your resources before deploying and save it in solutions.plan file.
10. Run "terraform apply" to finally deploy your infrastructure.


Note :- 
1. For deploying VM image through packer we have used resource group name as : 
"managed_image_resource_group_name" : "PackerImages"

2. Use same name in terraform main.tf file as shown below:

data "azurerm_image" "ubuntu_image" {

    name = "Ubuntu1804-LTS"
    resource_group_name = "PackerImages"
}

3. You have to create resource group before deploying image as packer does not create resource groups.

#Output

Your infrastructure is created in resource group.