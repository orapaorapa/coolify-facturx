FROM eclipse-temurin:17-jre

RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/mustang

RUN curl -L -o Mustang-CLI.zip https://www.mustangproject.org/deploy/Mustang-CLI-2.22.0.zip \
    && unzip Mustang-CLI.zip \
    && rm Mustang-CLI.zip \
    && find /opt/mustang -iname "Mustang-CLI-*.jar" -exec cp {} /opt/mustang/Mustang-CLI.jar \;

WORKDIR /data

COPY watcher.sh /watcher.sh
RUN chmod +x /watcher.sh

ENTRYPOINT ["/watcher.sh"]