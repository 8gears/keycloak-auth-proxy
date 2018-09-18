FROM quay.io/gambol99/keycloak-proxy:v2.1.1
EXPOSE 8080
COPY start-proxy.sh .
RUN chmod -R g+rwX . && chmod 755 -R . 
ENTRYPOINT []
CMD ["/opt/start-proxy.sh"]