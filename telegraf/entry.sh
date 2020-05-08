#!/bin/bash
if [[ $INFLUX_TOKEN && $INFLUX_ORG && $INFLUX_BUCKET && $INFLUX_URL ]]; then
  echo 'InfluxDB variables are defined - cloud enabled'
  sed -i '/InfluxDBCloud/,/EndInfluxDBCloud/ { s/^##*//; s/^ InfluxDBCloud$/# InfluxDBCloud/; s/^ EndInfluxDBCloud/# EndInfluxDBCloud/ }' /etc/telegraf/telegraf.conf
fi

if [[ $TELEGRAF_MQTT_URL_PORT == "INTERNAL" ]]; then
  TELEGRAF_MQTT_URL_PORT="mqtt:1883"
  echo 'Internal MQTT server specified for Telegraf - enabling MQTT output to '$TELEGRAF_MQTT_URL_PORT
  sed -i '/MQTTOutput/,/EndMQTTOutput/ { s/^##*//; s/^ MQTTOutput$/# MQTTOutput/; s/^ EndMQTTOutput/# EndMQTTOutput/ }' /etc/telegraf/telegraf.conf
fi

#Rename this container's hostname
echo 'Changing hostname to raspair'
hostname raspair

exec telegraf
