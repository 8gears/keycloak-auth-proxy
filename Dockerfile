FROM openjdk:8-jre-alpine

ENV KEYCLOAK_VERSION=3.0.0.Final \
    DOCKERIZE_VERSION=v0.4.0

WORKDIR /app
COPY proxy.tmpl .
COPY start-proxy.sh .

RUN apk --no-cache add ca-certificates openssl unzip &&\
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz &&\
    wget http://central.maven.org/maven2/org/keycloak/keycloak-proxy-dist/$KEYCLOAK_VERSION/keycloak-proxy-dist-$KEYCLOAK_VERSION.zip && \
    unzip keycloak-proxy-dist-$KEYCLOAK_VERSION.zip && mv keycloak-proxy-$KEYCLOAK_VERSION/* . && rm -rf keycloak-proxy* && \
    chmod 755 start-proxy.sh &&\
    chmod -R g+rwX /app    

EXPOSE 80 443

CMD ["/app/start-proxy.sh"]