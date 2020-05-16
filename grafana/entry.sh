#!/bin/bash
urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

if [[ -z $INFLUX_TOKEN || -z $INFLUX_ORG || -z $INFLUX_BUCKET  || -z $INFLUX_URL ]]; then
  echo 'Grafana raspair: One or more InfluxCloud variables are undefined'
else
  echo 'Grafana raspair:	InfluxCloud variables are defined'
  echo 'Grafana raspair:	Configuring datasource'
  echo "encoded org is: $(urlencode $INFLUX_ORG)"
  sed -i "s/#bucket/$INFLUX_BUCKET/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  sed -i "s/#organization/$(urlencode $INFLUX_ORG)/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  sed -i "s/#token/$INFLUX_TOKEN/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  sed -i "s/#url/$INFLUX_URL/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  cat /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  echo 'Grafana raspair:	Configuring dashboards'
  sed -i "s/#bucket/$INFLUX_BUCKET/g" /usr/src/app/provisioning/dashboards/raspair.json

  /usr/src/app/api.sh &
  exec grafana-server -homepath /usr/share/grafana
fi

