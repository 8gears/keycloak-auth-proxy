# Keycloak Auth Proxy

The Keycloak Auth Proxy makes it possible to protect web resources that have no build in authentication.

This Auth Proxy Service uses [Keycloak Proxy][kcp] a Java/Undertow solution designed for Keycloak but that should work with any other IMA that support OpenID/Connect.

## How is it working

![How reverse auth proxy works][prx_diag]

1. External traffic is directed to the auth proxy. The Auth proxy decides based on it configuration if the destination needs authentication.
2. The Auth Proxy work together with the IAM (Keycloak) and redirects the user to the IAM so the user can login.
3.  After a successful login the proxy forwards the user to the protected content. According to proxy configuration setting the proxy checks if the user is allowed to access the path.

## Use cases

There are two very common use cases why one would use the Keycloak Auth Proxy together with an Identity & Access Management Service (IAM)

- Protect static websites from unauthorized access only allowing authenticated users to see the content.  
  This is useful in combination with static website generator or other generated documentation.
- Outsource the authentication/authorization to Keycloak Auth Proxy and just relay on the header parameter with username and grants which are forwarded to the upstream application.


## Usage 

The proxy configuration settings can be set with environment variables or with the file `proxy.json` mounted as a volume to `/app/proxy.json`.

The intended use is that for every service that needed authentication there is an dedicated auth proxy. Auth proxy can be configured to behave differently but not given the configuration via environment variable. 

## Environment Variables
Can be used if you want to auth one service.

See the file [proxy.tmpl](proxy.tmpl)

Variables without default values are mandatory.

- `TARGET_URL` The URL to forward the traffic through
- `HTTP_PORT` (default `80`) The port to bind the Auth Proxy too
- `BASE_PATH` (default `/` )
- `REALM` Adapter config realm
- `REALM_PUBLIC_KEY`Realm public key
- `AUTH_SERVER_URL` The auth server URL 
- `RESOURCE` (default `account`) The resource to request aka client id
- `SECRET` Credential secret
- `CONSTRAINT_PATH` (default `/*`) You can define multiple path but they must be separated with a `;`

## Alternatives

Despite the uniqueness of _keycloak-auth-proxy_ there are other project that solve the similar problem differently.

- [OpenID / Keycloak Proxy service](https://github.com/gambol99/keycloak-proxy) This in Golang written proxy should work nicely with Keycloak and might be a value alternative to the current jvm proxy.
- [OAuth2 Proxy](https://github.com/bitly/oauth2_proxy)
- [Lua Resty OpenID/Connect](https://github.com/pingidentity/lua-resty-openidc) This library is designed for Nginx/OpenResty. 

<!-- Links -->

[kcp]: https://github.com/keycloak/keycloak/tree/master/proxy
[prx_diag]: https://cdn.rawgit.com/8gears/keycloak-auth-proxy/master/docs/images/How_Keycloak_Auth_Proxy_works.svg
