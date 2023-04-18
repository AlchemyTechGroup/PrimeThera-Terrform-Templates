#Resource group from each environment
data "azurerm_resource_group" "dev-rg" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  name = each.value.rg_dev
  provider = azurerm.non-prod
}
data "azurerm_resource_group" "tst-rg" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  name = each.value.rg_tst
  provider = azurerm.non-prod
}
# Assign Contributor permission to the service principals
resource "azurerm_role_assignment" "sp-dev-roleassignment" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  scope              = data.azurerm_resource_group.dev-rg[each.value.kv_name].id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.sp-non-prod[each.value.kv_name].object_id
  depends_on = [resource.azuread_service_principal.sp-non-prod]
  provider = azurerm.non-prod
}
resource "azurerm_role_assignment" "sp-tst-roleassignment" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  scope              = data.azurerm_resource_group.tst-rg[each.value.kv_name].id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.sp-non-prod[each.value.kv_name].object_id
  depends_on = [resource.azuread_service_principal.sp-non-prod]
  provider = azurerm.non-prod
}