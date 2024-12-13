FROM docker.elastic.co/beats/elastic-agent:8.15.0

COPY otel-collector-config.yaml /etc/otelcol-contrib/config.yaml

ENTRYPOINT ["/usr/share/elastic-agent/elastic-agent"]

CMD ["otel", "--config", "/etc/otelcol-contrib/config.yaml", "--feature-gates=-component.UseLocalHostAsDefaultHost"]
EXPOSE 4317 55679 4318
