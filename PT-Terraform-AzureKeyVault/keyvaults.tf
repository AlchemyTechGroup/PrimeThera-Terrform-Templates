data "azurerm_resource_group" "rg_dev" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  name = each.value.rg_dev
  provider = azurerm.non-prod
}
data "azurerm_resource_group" "rg_tst" {
  for_each = {for p in var.p_data:  p.kv_name => p}
  name = each.value.rg_tst
  provider = azurerm.non-prod
}
resource "azurerm_key_vault" "kv-dev" {
  for_each = {for p in var.p_data:  p.kv_name => p}  
  name                        = "${each.value.kv_name}-dev"
  location                    = data.azurerm_resource_group.rg_dev[each.value.kv_name].location
  resource_group_name         = data.azurerm_resource_group.rg_dev[each.value.kv_name].name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_subscription.s_non_prod.tenant_id
  soft_delete_retention_days  = 14
  purge_protection_enabled    = true
  provider = azurerm.non-prod 
  sku_name = "standard"
  depends_on = [azuread_service_principal.sp-non-prod]
}
resource "azurerm_key_vault" "kv-tst" {
  for_each = {for p in var.p_data:  p.kv_name => p}  
  name                        = "${each.value.kv_name}-tst"
  location                    = data.azurerm_resource_group.rg_tst[each.value.kv_name].location
  resource_group_name         = data.azurerm_resource_group.rg_tst[each.value.kv_name].name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_subscription.s_non_prod.tenant_id
  soft_delete_retention_days  = 14
  purge_protection_enabled    = true
  provider = azurerm.non-prod
  sku_name = "standard"
  depends_on = [azuread_service_principal.sp-non-prod]
}