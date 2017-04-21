# Keycloak Auth Proxy

The Keycloak Auth Proxy Container provides OpenID Connect/OAuth authentication and authorization for web resources or services that don't have a build in authentication.

This Auth Proxy Service uses [Keycloak Proxy][kcp], which is a Java/Undertow solution designed for Keycloak. However it should also work with any other OpenID Connect Provider.

What makes this project special is, that it can be configured with environment variables and can be easily deployed to Docker, Kubernetes or OpenShift. 

## Mode of operation

![How reverse auth proxy works][prx_diag]

1. External traffic is directed to the auth proxy. The Auth proxy decides based on it configuration if the destination needs authentication.
2. The Auth Proxy work together with the IAM (Keycloak) and redirects the user to the IAM so the user can login.
3.  After a successful login the proxy forwards the user to the protected content. According to proxy configuration setting the proxy checks if the user is allowed to access the path.

## Typical Use cases

There are two very common use cases why one would use the Keycloak Auth Proxy in combination with an Identity & Access Management Service (IAM).

- Protect static websites from unauthorized access, allowing only authenticated users to see the content.  
  This is useful in combination with static website generator or other generated documentation.
- Outsource the authentication/authorization step to Keycloak Auth Proxy and just relay on the forward HTTP headers with username/grants in the upstream application.   
  This approach can be handy if you have an application, where there are no OpenID Connect library or if you don't won't perform to many changes in the application. 

## Usage

The proxy configuration settings can be set with environment variables or with the file `proxy.json` mounted as a volume to `/app/proxy.json`.

Set the mandatory environment variables.
```
docker run -ti \
-e TARGET_URL=asdf \
-e REALM="realm" \
-e REALM_PUBLIC_KEY='pub'
-e .... \
8gears/keycloak-auth-proxy
```

With Compose adapt the env variables in `docker-compose.yml` and hit:
```
wget https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/docker-compose.yml 
docker-compose - up
```

The intended use is, that every service that needs authentication has a dedicated auth proxy in front of it.
However the Auth Proxy can be configured to behave differently, but not with the given the configuration via environment variable. 
For this  case you have to mount the self created `proxy.json` for example.

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
