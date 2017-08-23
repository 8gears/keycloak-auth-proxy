#!/bin/sh

if [ -n "$PROXY_CONFIG" ]; then
    echo "Using the provided proxy json/yml file"
    echo $PROXY_CONFIG > /opt/proxy.config
    export $PROXY_CONFIG_FILE=/opt/proxy.config
fi

if [-e "/opt/proxy.config" ]
then    
    /opt/keycloak-proxy --config $PROXY_CONFIG_FILE
else
    ## parse ENV Vars    
    # $PROXY_DISCOVERY_URL
    # $PROXY_CLIENT_ID
   /opt/keycloak-proxy --listen :8080 --enable-refresh-token: $PROXY_ENABLE_REFRESH_TOKEN --secure-cookie $PROXY_SECURE_COOKIE --resources ${PROXY_RESOURCES}
fi

