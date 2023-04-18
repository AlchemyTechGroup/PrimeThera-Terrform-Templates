data "azuread_client_config" "current" {}
#Service principal
resource "azuread_application" "app-non-prod" {
  for_each = {for p in var.p_data:  p.kv_name => p} 
  display_name = "KV-${each.value.kv_name}"
  owners       = [data.azuread_client_config.current.object_id]
}
resource "azuread_service_principal" "sp-non-prod" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  application_id               = azuread_application.app-non-prod[each.value.kv_name].application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
feature_tags {
    enterprise = true
    gallery    = true
  }
}
resource "azuread_service_principal_password" "sp-non-prod-passwd" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  service_principal_id = azuread_service_principal.sp-non-prod[each.value.kv_name].object_id
}