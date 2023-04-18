variable "p_data" {
    type = list(object({
      kv_name = string,
      rg_dev = string,
      rg_tst = string,
      proyecto_ado = string,
      devops = list(string)
  
  }))
  default = [
     {
      kv_name = "akvname" 
      rg_dev = "a-dev-rg"
      rg_tst = "a-tst-rg"
      proyecto_ado = "A_PROJECT"
      devops = ["devops1@gmail.com", "devops2@gmail.com"]
      },
     {
      kv_name = "bkvname" 
      rg_dev = "b-dev-rg"
      rg_tst = "b-tst-rg"
      proyecto_ado = "B_PROJECT"
      devops = ["devops11@gmail.com"]
     },
     {
      kv_name = "ckvname" 
      rg_dev = "c-dev-rg"
      rg_tst = "c-tst-rg"
      proyecto_ado = "C_PROJECT"
      devops = ["devops3@gmail.com", "devops4@gmail.com", "devops5@gmail.com"]
     }
  ]
}
data "azurerm_subscription" "s_non_prod" {
  subscription_id = var.sub_id_dev
  provider = azurerm.non-prod
}