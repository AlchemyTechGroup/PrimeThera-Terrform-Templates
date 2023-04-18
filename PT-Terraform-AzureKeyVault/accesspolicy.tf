locals {
flattened-pdata =  flatten([
    for pos, kv in var.p_data : [
      for pos2, devops in var.p_data[pos].devops : {
        kv_name = kv.kv_name
        devops_name = kv.devops[pos2]
    }]
  ])
}
data "azuread_user" "user-ad" {
   for_each = {
    for devops in local.flattened-pdata : "${devops.kv_name}.${devops.devops_name}" => devops
    }
user_principal_name = each.value.devops_name
}
#Access policy assign to devops
#DEV
resource "azurerm_key_vault_access_policy" "kv-pol-devops-dev" {
for_each = {
    for devops in local.flattened-pdata : "${devops.kv_name}.${devops.devops_name}" => devops
    }
key_vault_id = azurerm_key_vault.kv-dev[each.value.kv_name].id
      tenant_id = data.azurerm_subscription.s_non_prod.tenant_id
      object_id = data.azuread_user.user-ad["${each.value.kv_name}.${each.value.devops_name}"].object_id
key_permissions = [
      "get","list","update","create","import","delete","recover","backup","restore",
      ]
secret_permissions = [
      "get","list","set","delete","recover","backup","restore",
      ]
storage_permissions = [
      "get","list",
      ]  
      depends_on = [
        azurerm_key_vault.kv-dev
      ]
      provider = azurerm.non-prod
}
#TST
resource "azurerm_key_vault_access_policy" "kv-pol-devops-tst" {
for_each = {
    for devops in local.flattened-pdata : "${devops.kv_name}.${devops.devops_name}" => devops
    }
key_vault_id = azurerm_key_vault.kv-tst[each.value.kv_name].id
      tenant_id = data.azurerm_subscription.s_non_prod.tenant_id
      object_id = data.azuread_user.user-ad["${each.value.kv_name}.${each.value.devops_name}"].object_id
key_permissions = [
      "get","list","update","create","import","delete","recover","backup","restore",
      ]
secret_permissions = [
      "get","list","set","delete","recover","backup","restore",
      ]
storage_permissions = [
      "get","list",
      ]
    
     depends_on = [
        azurerm_key_vault.kv-tst
      ]
      provider = azurerm.non-prod
}
#Access policy assign to service connection's service principals.
#DEV
resource "azurerm_key_vault_access_policy" "kv-pol-sp-dev" {
  for_each = {for p in var.p_data:  p.kv_name => p}
key_vault_id = azurerm_key_vault.kv-dev[each.value.kv_name].id
  tenant_id = data.azurerm_subscription.s_non_prod.tenant_id
  object_id = azuread_service_principal.sp-non-prod[each.value.kv_name].object_id
key_permissions = [
      "get","list",
    ]
secret_permissions = [
      "get","list",
    ]
storage_permissions = [
      "get","list",
    ]
depends_on = [
        azurerm_key_vault.kv-dev
    ]
provider = azurerm.non-prod
}
#TST
resource "azurerm_key_vault_access_policy" "kv-pol-sp-tst" {
  for_each = {for p in var.p_data:  p.kv_name => p}
key_vault_id = azurerm_key_vault.kv-tst[each.value.kv_name].id
  tenant_id = data.azurerm_subscription.s_non_prod.tenant_id
  object_id = azuread_service_principal.sp-non-prod[each.value.kv_name].object_id
  
   key_permissions = [
      "get","list",
    ]
secret_permissions = [
      "get","list",
    ]
storage_permissions = [
      "get","list",
    ]
  
   depends_on = [
        azurerm_key_vault.kv-tst
    ]
   provider = azurerm.non-prod
}