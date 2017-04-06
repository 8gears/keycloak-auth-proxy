# Keycloak Auth Proxy

The Keycloak Auth Proxy makes it possible to protect web resources that have no build in authentication.

## How is it working


```                                                                                                                                     
+------------+ 
|            | 
|  Internet  |
|            |
+------|-----+
       |      
       |      
       |      
+------|-----+               +------------+    
|            |               |            |
| Auth Proxy -----------------  Keycloak  |
|            |               |            |
+------|-----+               +------------+
       |                                   
       |                                   
       |                                   
+------|-----+                             
|   Secured  |                             
|   Content  |                             
|            |                             
+------------+                             
```

## Usecases

There are two very common usecases why one would like to use Keycloak Auth Proxy together with an Identity & Access Management Service (IAM)

- Protect static website and allow only authenticated users to see the content
- Outsource the authentication to Keycloak Auth Proxy on just relay on the header parameter about the user then Keycloak Auth Proxy forward  to you.

## Alternatives

Despite the uniqueness of _keycloak-auth-proxy_ there are other project that solve the similar problem differently.

...

