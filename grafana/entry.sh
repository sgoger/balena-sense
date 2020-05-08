#!/bin/bash
if [[ -z $INFLUX_TOKEN || -z $INFLUX_ORG || -z $INFLUX_BUCKET  || -z $INFLUX_URL ]]; then
  echo 'Grafana raspair: One or more InfluxCloud variables are undefined'
else
  echo 'Grafana raspair: InfluxCloud variables are defined - configuring datasource'
  sed -i "s/#bucket/$INFLUX_BUCKET/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  sed -i "s/#organization/$INFLUX_ORG/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  sed -i "s/#token/$INFLUX_TOKEN/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
  sed -i "s/#url/$INFLUX_URL/g" /usr/src/app/provisioning/datasources/influxdb-datasource.yml
fi

/usr/src/app/api.sh &
exec grafana-server -homepath /usr/share/grafana
