resource "azurerm_app_service_plan" "plan" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "plan-${var.project}"
  location            = var.location

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "callee_api" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "web-${var.project}-callee-api"
  location            = var.location

  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    always_on                 = true
    dotnet_framework_version  = "v5.0"
    ftps_state                = "Disabled"
    use_32_bit_worker_process = false
    min_tls_version           = "1.2"
    scm_type                  = "LocalGit"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.ai.instrumentation_key
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
    "PROJECT" = "src/callee-api/WebApiWithAzureAd.CalleeApi.csproj"
  }
}
