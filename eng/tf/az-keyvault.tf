resource "azurerm_key_vault" "kv" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "kv-${var.project}"
  location            = var.location

  sku_name  = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault_access_policy" "spn" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["get", "list", "set", "delete"]
}

resource "azurerm_key_vault_access_policy" "caller_api" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.caller_api.identity.0.principal_id

  secret_permissions = ["get", "list"]
  depends_on         = [azurerm_key_vault_access_policy.spn]
}

resource "azurerm_key_vault_secret" "caller_api_secret" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "CallerApi--ClientSecret"
  value        = azuread_application_password.caller_api.value
}
