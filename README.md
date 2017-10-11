# Keycloak Auth Proxy

[![Anchore Image Overview](https://anchore.io/service/badges/image/2387ff5c51f57a1b6e7cffc65f400bf47a9962bd57dea8a050cf7f941937bd17)](https://anchore.io/image/dockerhub/2387ff5c51f57a1b6e7cffc65f400bf47a9962bd57dea8a050cf7f941937bd17?repo=8gears%2Fkeycloak-auth-proxy&tag=goproxy)
[![Docker Automated build](https://img.shields.io/docker/automated/8gears/keycloak-auth-proxy.svg?style=flat-square)](https://hub.docker.com/r/8gears/keycloak-auth-proxy/)
[![Docker Pulls](https://img.shields.io/docker/pulls/8gears/keycloak-auth-proxy.svg?style=flat-square)](https://hub.docker.com/r/8gears/keycloak-auth-proxy/)
[![Docker Stars](https://img.shields.io/docker/stars/8gears/keycloak-auth-proxy.svg?style=flat-square)](https://hub.docker.com/r/8gears/keycloak-auth-proxy/)


The Reverse Auth Proxy Container provides OpenID Connect/OAuth authentication and authorization for web resources or services that don't have a build in authentication.

This Auth Proxy Service uses [Keycloak Proxy][kcp], which is a Java/Undertow solution designed for Keycloak. However it should also work with any other OpenID Connect Provider.

What makes this project special is, that it can be configured with environment variables and can be easily deployed to Docker, Kubernetes or OpenShift. 

## Note

We are migrating the Java Proxy Version (that comes with Keycloak) to [gambol99/keycloak-proxy](https://github.com/gambol99/keycloak-proxy). You can switch to the branch [goproxy](/tree/goproxy).
The new Go Proxy implementation is more general purpose, needs less resources and has some usefull options that are missing in the Keycloak version. (Let's Encrypt Support, Login/Logout and Forward Signing Proxy). A Working version is availible on Docker Hub as `docker pull 8gears/keycloak-auth-proxy:goproxy`

## Mode of operation

![How reverse auth proxy works][prx_diag]

1. External traffic is directed to the auth proxy. The Auth proxy decides based on it configuration if the destination needs authentication.
2. The Auth Proxy work together with the IAM (Keycloak) and redirects the user to the IAM so the user can login.
3.  After a successful login the proxy forwards the user to the protected content. According to proxy configuration setting the proxy checks if the user is allowed to access the path.

## Typical Use cases

There are two very common use cases why one would use the Keycloak Auth Proxy in combination with an Identity & Access Management Service (IAM).

It is recommended that every service that needs authentication has a dedicated auth proxy in front of it.

- Protect static websites from unauthorized access, allowing only authenticated users to see the content.  
  This is useful in combination with static website generator or other generated documentation.
- Outsource the authentication/authorization step to Keycloak Auth Proxy and just relay on the forward HTTP headers with username/grants in the upstream application.   
  This approach can be handy if you have an application, where there are no OpenID Connect library or if you don't won't perform to many changes in the application. 

## Usage

There are three ways how the proxy can be configured. 
The proxy configuration settings can be set with environment variables,environment variables plus config template or with the file `proxy.json` mounted as a volume to `/app/proxy.json`.

The option that you choose depend on the use case. For simple static website auth the default proxy template is sufficient. For more complex scenarios the custom Proxy Config Template is able cover all possible options.

### Running with the default Proxy Config Template

In the simplest case the only thing you need to do is to set the mandatory environment variables. Prior the execution the variables merged with the default proxy config and then the proxy application is started.

```
docker run -ti \
-e TARGET_URL=asdf \
-e REALM="realm" \
-e REALM_PUBLIC_KEY='pub'
-e .... \
8gears/keycloak-auth-proxy
```

With Docker Compose download the default docker-compose.yml 
```
wget https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/docker-compose.yml 
```

Adapt the mandatory env variables in `docker-compose.yml` and hit:
```
docker-compose - up
```

### Running with custom Proxy Config Template

In order to combine the simplicity of the environment variables with the flexibility of the custom proxy config it is possible to provide your own template.

Take the existing `proxy.tmpl` from this repository and extended it to your need.
When you are done with the template minfy the content and set the variable ??`PROXY_TMPL` with the content.

```
docker run -ti \
-e PROXY_TMPL={"target-url": "http://172.17.0.2:2015","bind-address": "0.0.0.0", ....
-e TARGET_URL=asdf \
-e REALM="realm" \
-e REALM_PUBLIC_KEY='pub'
-e .... \
8gears/keycloak-auth-proxy
```

### Running with custom Proxy Config 

Write your `proxy.json` file and mount it to `/app/proxy.json`. Prior start the Auth proxy startup script will check if the file exist and start the proxy with the provided file ignoring the template or any provided environment variables.

Instead of mapping you can provide the content via environment variable ?`PROXY_JSON` just like in the template example above.

```
docker run -v proxy.json:/app/proxy.json 8gears/keycloak-auth-proxy 
```

## Environment Variables
Can be used if you want to auth one service.

See the file [proxy.tmpl](proxy.tmpl)

Variables without default values are mandatory.

- `TARGET_URL` The URL to forward the traffic through
- `HTTP_PORT` (default `8080`) The port to bind the Auth Proxy too
- `BASE_PATH` (default `/` )
- `REALM` Adapter config realm
- `REALM_PUBLIC_KEY` Realm public key
- `AUTH_SERVER_URL` The auth server URL 
- `RESOURCE` (default `account`) The resource to request aka client id
- `SECRET` Credential secret
- `CONSTRAINT_PATH` (default `/*`) You can define multiple path but they must be separated with an `;`
- `PROXY_TMPL` Instead of using the provided proxy config it is possible to provide a custom config.

## OpenShift Deployment

In OpenShift you can create the service from the template `openshift_template.yml` by using the Web UI or CLI.

Copy the content of `openshift_template.yml` and paste it to the *Import YAML / JSON* tab in the service catalog. 
The OpenShift has a [detailed tutorial]([create_from_ui]) that covers the manual template instantiation.

From the CLI execute the first command with the `--parameter` argument to get a list of all the possible parameters.
Next in the second command add all the needed parameters and pipe it to create.

```
oc process --parameter -f https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/openshift_template.yml

oc process -f https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/openshift_template.yml \
    -p TARGET_URL=http://service-name:123 \
    -p REALM=app42 \
    | oc create -f -

```

### OpenShift Service Catalog import
Import the template to the current namespace service catalog.

```
oc create -f https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/openshift_template.yml
```

Import template to global service catalog, so all users in all namespaces can use that template.

```
oc create -f https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/openshift_template.yml -n openshift
```


## Alternatives

Despite the uniqueness of _keycloak-auth-proxy_ there are other project that solve the similar problem differently.



- [OpenID / Keycloak Proxy service](https://github.com/gambol99/keycloak-proxy) This in Golang written proxy should work nicely with Keycloak and might be a value alternative to the current jvm proxy.
- [OAuth2 Proxy](https://github.com/bitly/oauth2_proxy)
- [Lua Resty OpenID/Connect](https://github.com/pingidentity/lua-resty-openidc) This library is designed for Nginx/OpenResty. 

<!-- Links -->

[kcp]: https://github.com/keycloak/keycloak/tree/master/proxy
[prx_diag]: https://cdn.rawgit.com/8gears/keycloak-auth-proxy/master/docs/images/How_Keycloak_Auth_Proxy_works.svg
[create_from_ui]: https://docs.openshift.org/latest/dev_guide/templates.html#creating-from-templates-using-the-web-console
