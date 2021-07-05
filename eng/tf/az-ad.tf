resource "azuread_application" "callee_api" {
  display_name    = "APP-${upper(var.project)}-CALLEE-API"
  identifier_uris = ["api://app-${lower(var.project)}-callee-api"]

  app_role {
    allowed_member_types = ["Application"]
    description          = "Authorized caller can call the API"
    display_name         = "Caller"
    value                = "caller"
  }
}

resource "azuread_application" "caller_api" {
  display_name    = "APP-${upper(var.project)}-CALLER-API"
  identifier_uris = ["api://app-${lower(var.project)}-caller-api"]

  required_resource_access {
    resource_app_id = azuread_application.callee_api.application_id

    resource_access {
      id   = element(azuread_application.callee_api.app_role[*].id, 0)
      type = "Role"
    }
  }
}

resource "azuread_application_password" "caller_api" {
  application_object_id = azuread_application.caller_api.object_id
  display_name          = "LocalDevSecret"
}
