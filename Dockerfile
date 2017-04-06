FROM openjdk:8-jre-alpine

ENV KEYCLOAK_VERSION 3.0.0.Final
ENV DOCKERIZE_VERSION v0.4.0

RUN apk --no-cache update && apk add ca-certificates openssl unzip &&\
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz 
RUN wget http://central.maven.org/maven2/org/keycloak/keycloak-proxy-dist/$KEYCLOAK_VERSION/keycloak-proxy-dist-$KEYCLOAK_VERSION.zip && \
    unzip keycloak-proxy-dist-$KEYCLOAK_VERSION.zip && mv keycloak-proxy-$KEYCLOAK_VERSION /app && rm keycloak-proxy-dist-$KEYCLOAK_VERSION.zip && \
    chmod -R g+rwX /app

EXPOSE 8080 8443

WORKDIR /app

CMD ["java", "-jar", "bin/launcher.jar"]
