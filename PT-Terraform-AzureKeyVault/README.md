main.tf
Where we configure our terraform required providers

providers.tf
Configuration of azure devops and azurerm providers

variables.tf
Here we define the variables about each one of the projects. We can add the amount of projects we need:

kv_name = key vault name we will assign for that particular project
rg_dev = development resource group
rg_tst = testing resource group
proyecto_ado = azure devops project’s name
devops = user’s emails who will have access to modify the key vault.

servicep.tf
To generate the integration between key vaults and azure devops projects, we will need to create a service principal for each key vault. This will allows us to create the service connections later.

roleassign.tf
We must assign the role "Contributor" to the previous service principals created in each one of the key vaults.

keyvaults.tf
In this file, we will create the key vaults per project. One per environment

sc.tf
Creation of the service connections in each Azure DevOps Project.

accesspolicy.tf
The access policy is the permission we give at each key vault to create, get, delete secrets and more.

In this file, we assign the access policy to all the users we defined in the 02-variables.tf with the list of permissions we require.

And we also assign the access policy to the service principals of the service connections with "get" and "list" permissions.


Script execution
To execute these scripts you have to write in the command line the following steps:

terraform init → it initializes the terraform.
terraform plan -var-file=variables.tfvars → it generates a plan in the command line about the changes it would do, using the file with your variables "variables.tfvars".
terraform apply -var-file=variables.tfvars → it will apply your changes if you confirm to "yes". See the example: