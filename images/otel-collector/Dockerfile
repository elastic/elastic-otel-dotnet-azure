FROM otel/opentelemetry-collector-contrib:0.91.0

COPY otel-collector-config.yaml /etc/otelcol-contrib/config.yaml

ENTRYPOINT ["/otelcol-contrib"]

CMD ["--config", "/etc/otelcol-contrib/config.yaml", "--feature-gates=-component.UseLocalHostAsDefaultHost"]
EXPOSE 4317 55679 4318
