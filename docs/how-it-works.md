# How it works

Ingress instances mounts `html`, `certs`, `conf.d` and `vhost.d` volumes and `conf` files in read-only mode.
Docker-gen instances mounts `certs` and `vhost.d` volumes and `templates` file in read-only mode, and `conf.d` volume in read-write mode.
Acme-companion instances mount `acme`, `html` and `certs` volume in read-write mode.

# Single Ingress instance

```text
                    +------------------------+
                    | acme-companion (4) (6) |
                    +------------------------+
                                 :
                                (7)
                                 :
                      +--------------------+
                      | docker-gen (2) (8) |
                      +--------------------+
                                 :
+-------------------+         (3) (9)
| ACME Provider (5) | --+        :
+-------------------+   |   +---------+
                        +-> | Ingress |
+------+                |   +---------+
| User | ---------------+        |
+------+                         V
                       +------------------+
                       | Your 1st App (1) |
                       +------------------+
```

1. App container started
2. Writes default nginx config file in `conf.d` volume based on `templates` file.
3. Sends HUP signal to Ingress container to reload configuration
4. Creates ACME challenge in `html` volume and triggers ACME provider
5. ACME provider validates challenge and sign certificates
6. Stores signed certificates in `certs` volume
7. Sends HUP signal to docker-gen container to update configuration
8. Adds certs and TLS configuration to vhost's https server and redirects http to https to default conf file in `conf.d`.
9. Sends HUP signal to Ingress container to reload configuration

# Dual Ingress instances

```text
                                    +------------------------+
                                    | acme-companion (4) (6) |
                                    +------------------------+
                                                :
                                               (7)
                                                :
                                    +-----------------------+
                                    | signal-propagator (8) |
                                    +-----------------------+
                                                :
                                               (9)
                              ..................:...................
                              :                                    :
                +----------------------------+      +-----------------------------+
                | docker-gen Public (2) (10) |      | docker-gen Private (2) (10) |
                +----------------------------+      +-----------------------------+
                              :                                    :
                           (3) (11)                             (3) (11)
                              :......                       .......:
+-------------------+               :                       :
| ACME Provider (5) | --+           :                       :
+-------------------+   |   +----------------+     +-----------------+     +---------------+
                        +-> | Ingress Public |     | Ingress Private | <-- | Internal User |
+---------------+       |   +----------------+     +-----------------+     +---------------+
| External User | ------+           |                       |
+---------------+                   +-----------------------+
                                                |
                                                V
                                       +------------------+
                                       | Your 1st App (1) |
                                       +------------------+
```

1. App container started
2. Writes default nginx config file in `conf.d` volume based on `templates` file.
3. Sends HUP signal to Ingress container to reload configuration
4. Creates ACME challenge in `html` volume and triggers ACME provider
5. ACME provider validates challenge and sign certificates
6. Stores signed certificates in `certs` volume
7. Sends HUP signal to signal-propagator
8. Propagates HUP signal to containers having label=com.github.eorea.signal-propagator.target
9. Sends HUP signal to docker-gen containers to update configuration
10. Adds certs and TLS configuration to vhost's https server and redirects http to https to default conf file in `conf.d`.
11. Sends HUP signal to Ingress container to reload configuration
