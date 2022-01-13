terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.9"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = "azure-cli-2022-01-12-12-45-17"
  tenant_id         = "0b16002b-2d76-47b9-ad0d-44e8af665640"
  client_id         = "e1cb0e86-c362-4b34-a75a-048bda004d16"
  client_secret     = "N.OZqWuv6EBoloIBL-FSGHiECU7XNPdLhL"
}

resource "azurecaf_name" "app_service_plan" {
  name          = var.application_name
  resource_type = "azurerm_app_service_plan"
  suffixes      = [var.environment]
}

# This creates the plan that the service use
resource "azurerm_app_service_plan" "application" {
  name                = azurecaf_name.app_service_plan.result
  resource_group_name = var.resource_group
  location            = var.location

  kind     = "Linux"
  reserved = true

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurecaf_name" "app_service" {
  name          = var.application_name
  resource_type = "azurerm_app_service"
  suffixes      = [var.environment]
}

# This creates the service definition
resource "azurerm_app_service" "application" {
  name                = azurecaf_name.app_service.result
  resource_group_name = var.resource_group
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.application.id
  https_only          = true

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }

  site_config {
    linux_fx_version          = "JAVA|11-java11"
    always_on                 = false
    use_32_bit_worker_process = true
    ftps_state                = "FtpsOnly"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

    # These are app specific environment variables
    "QUARKUS_HTTP_PORT" = 80
    "QUARKUS_PROFILE"   = "prod"

    "QUARKUS_DATASOURCE_JDBC_URL" = "jdbc:postgresql://${var.database_url}"
    "QUARKUS_DATASOURCE_USERNAME" = var.database_username
    "QUARKUS_DATASOURCE_PASSWORD" = var.database_password
  }
}
