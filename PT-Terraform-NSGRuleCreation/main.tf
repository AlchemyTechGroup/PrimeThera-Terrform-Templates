resource "azurerm_resource_group" "tamopsrg" {
  name     = "tamopsrg"
  location = "eastus2"
}
 
resource "azurerm_network_security_group" "tamopsnsg" {
  name                = "tamopstest"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.tamopsrg.name
 
}
 
resource "azurerm_network_security_rule" "testrules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.tamopsrg.name
  network_security_group_name = azurerm_network_security_group.tamopsnsg.name
}