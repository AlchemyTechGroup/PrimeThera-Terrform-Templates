provider "azuredevops" {
  org_service_url = var.org_service_url
  personal_access_token = var.pat
}
provider "azurerm" {
  features {}
  subscription_id =  var.sub_id_dev
  tenant_id = var.tenant_id
  client_id       = var.client_id 
  client_secret   = var.client_secret
  alias = "non-prod"
}