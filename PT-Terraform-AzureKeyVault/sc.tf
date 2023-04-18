resource "azuredevops_serviceendpoint_azurerm" "sc-akv-non-prod" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  project_id            = each.value.proyecto_ado
  service_endpoint_name     = upper("KV-${each.value.kv_name}-NON-PROD")
  description = "Managed by Terraform" 
  azurerm_spn_tenantid      = data.azurerm_subscription.s_non_prod.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.s_non_prod.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.s_non_prod.display_name
  credentials {
    serviceprincipalid  = azuread_service_principal.sp-non-prod[each.value.kv_name].application_id
    serviceprincipalkey = azuread_service_principal_password.sp-non-prod-passwd[each.value.kv_name].value
  }
}