#!/bin/sh

if [ -n "$PROXY_CONFIG" ]; then
    echo "Starting proxy and using the provided proxy json/yml file."
    echo $PROXY_CONFIG > /opt/proxy.config
    export $PROXY_CONFIG_FILE=/opt/proxy.config
    /opt/keycloak-proxy --verbose ${PROX_DEBUG: false} --config $PROXY_CONFIG_FILE 
else
    echo "Starting proxy."    
    export PROXY_LISTEN=${PROXY_LISTEN:-:8080}
    /opt/keycloak-proxy \
        --verbose=${PROX_DEBUG:=false} \
        --enable-refresh-tokens=${PROXY_ENABLE_REFRESH_TOKEN:=false} \
        --secure-cookie=${PROXY_SECURE_COOKIE:=true} \
        --resources=$PROXY_RESOURCES
fi
