locals {
  deployment = {
    nodered = {
      image       = "nodered/node-red:latest"
      int         = 1880
      ext         = 1880
      volume_path = "/data"
    }
    influxdb = {
      image       = "influxdb"
      int         = 8086
      ext         = 8086
      volume_path = "/var/lib/influxdb"
    }
    grafana = {
      image       = "grafana/grafana"
      int         = 3000
      ext         = 3000
      volume_path = "/var/lib/grafana"
    }
  }
}
