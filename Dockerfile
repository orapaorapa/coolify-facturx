FROM eclipse-temurin:17-jre

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/mustang

RUN curl -fL -o /opt/mustang/Mustang-CLI.jar https://www.mustangproject.org/deploy/Mustang-CLI-2.22.0.jar

WORKDIR /data

COPY watcher.sh /watcher.sh
RUN sed -i 's/\r$//' /watcher.sh && chmod +x /watcher.sh

ENTRYPOINT ["/bin/sh", "/watcher.sh"]
