# Keycloak Auth Proxy

The Keycloak Auth Proxy makes it possible to protect web resources that have no build in authentication.

This Auth Proxy Service uses [Keycloak Proxy][kcp] a Java/Undertow solution designed for Keycloak but that should work with any other IMA that support OpenID/Connect.

## How is it working

![How reverse auth proxy works][prx_diag]

1. External unauthenticated traffic is directed to the auth proxy. 
2. The Auth Proxy is configured to work together with the IAM and redirects the user to the IAM so the user can login.
3.  After a successful login the proxy forwards the user to the protected content. According to proxy configuration setting the proxy checks if the user is allowed to access the path.

## Use cases

There are two very common use cases why one would use the Keycloak Auth Proxy together with an Identity & Access Management Service (IAM)

- Protect static websites from unauthorized access only allowing authenticated users to see the content.  
  This is useful in combination with static website generator or other generated documentation.
- Outsource the authentication/authorization to Keycloak Auth Proxy and just relay on the header parameter with username and grants which are forwared to the upstream application.

## Alternatives

Despite the uniqueness of _keycloak-auth-proxy_ there are other project that solve the similar problem differently.

- [OpenID / Keycloak Proxy service](https://github.com/gambol99/keycloak-proxy) This in Golang written proxy should work nicely with Keycloak and might be a value alternative to the current jvm proxy.
- [OAuth2 Proxy](https://github.com/bitly/oauth2_proxy)
- [Lua Resty OpenID/Connect](https://github.com/pingidentity/lua-resty-openidc) This library is designed for Nginx/OpenResty. 


<!-- Links -->

[kcp]: https://github.com/keycloak/keycloak/tree/master/proxy
[prx_diag]: https://raw.githubusercontent.com/8gears/keycloak-auth-proxy/master/docs/images/How_Keycloak_Auth_Proxy_works.svg
