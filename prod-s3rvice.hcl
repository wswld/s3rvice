job "prod-s3rvice" {
  region = "global"
  datacenters = ["dataline"]
  type = "service"
  priority = 50
  update {
    max_parallel = 1
    stagger      = "60s"
  }
  group "prod-s3rvice" {
    count = 1
    constraint {
      operator  = "distinct_hosts"
      value     = "true"
    }
    task "prod-s3rvice" {
      driver = "docker"
      leader = true
      config {
        image = "__IMAGE__"
        command = "s3rvice"
        auth = {
          username = "***"
          password = "***"
          server_address = "***"
        }
        port_map = {
          "http" = 8000
        }
      }
      env {}
      service {
        name = "s3rvice"
        port = "http"
        tags = ["prod"]
        check {
          type     = "http"
          port     = "http"
          path     = "/ping"
          interval = "5s"
          initial_status = "critical"
          timeout  = "2s"
        }
      }
      resources {
        cpu = 1000
        memory = 512
        network {
          mbits = 10
          port "http" {}
        }
      }
      logs {
        max_files = 2
        max_file_size = 2
      }
    }
    restart {
      attempts = 5
      delay = "2s"
      mode = "delay"
      interval = "5m"
    }
  }
}
