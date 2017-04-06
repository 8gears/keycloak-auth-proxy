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

There are two very common usecases why you would like to use Keycloak Auth Proxy

- Protect static website and allow only authenticated users to see the content
- Outsource the authentication to Keycloak Auth Proxy on just relay on the header parameter about the user then Keycloak Auth Proxy forward  to you.


