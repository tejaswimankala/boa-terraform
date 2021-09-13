resource "kubernetes_config_map" "environment_config" {
  metadata {
    name = "environment-config"
  }

  data = {
    LOCAL_ROUTING_NUM = "883745000"

    PUB_KEY_PATH = "/root/.ssh/publickey"
  }
}

resource "kubernetes_config_map" "service_api_config" {
  metadata {
    name = "service-api-config"
  }

  data = {
    BALANCES_API_ADDR = "balancereader:8080"

    CONTACTS_API_ADDR = "contacts:8080"

    HISTORY_API_ADDR = "transactionhistory:8080"

    TRANSACTIONS_API_ADDR = "ledgerwriter:8080"

    USERSERVICE_API_ADDR = "userservice:8080"
  }
}

resource "kubernetes_config_map" "demo_data_config" {
  metadata {
    name = "demo-data-config"
  }

  data = {
    DEMO_LOGIN_PASSWORD = "password"

    DEMO_LOGIN_USERNAME = "testuser"

    USE_DEMO_DATA = "True"
  }
}
