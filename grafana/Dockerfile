FROM balenalib/raspberry-pi:buster

COPY ./grafana.ini /usr/share/grafana/conf/custom.ini
COPY ./provisioning /usr/src/app/provisioning
COPY ./*.sh /usr/src/app/
RUN chmod +x /usr/src/app/*.sh

RUN install_packages \
      fontconfig-config \
      fonts-dejavu-core \
      libfontconfig1 \
      ucf \
      jq \
      wget

RUN /usr/src/app/download.sh "rpi"

RUN dpkg -i /tmp/grafana.deb && rm /tmp/grafana.deb

RUN grafana-cli --pluginsDir "/usr/share/grafana/data/plugins" plugins install grafana-influxdb-flux-datasource

CMD ["/bin/sh","/usr/src/app/entry.sh"]
