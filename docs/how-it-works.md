# How it works

Ingress instances mounts `html`, `certs`, `conf.d` and `vhost.d` volumes and `conf` files in read-only mode.
Docker-gen instances mounts `certs` and `vhost.d` volumes and `templates` file in read-only mode, and `conf.d` volume in read-write mode.
Acme-companion instances mount `acme`, `html` and `certs` volume in read-write mode.

# Single Ingress instance

```mermaid
sequenceDiagram
  participant docker.sock@{ "type" : "entity" }
  participant ingress_public
  participant acme_companion
  participant docker_gen_public
  participant volumes@{ "type" : "collections" }

  par ingress_public
    rect rgb(32,128,64)
      loop on every notification
        docker.sock-)ingress_public: notifies Signal HUP<br/>(reload)
        volumes-->>ingress_public: reads config
        ingress_public->>ingress_public: reload config
      end
    end
  and acme_companion
    rect rgb(128,64,64)
      loop on every notification and every hour
        docker.sock-)acme_companion: notifies new container<br/>"Your app"
        acme_companion<<->>docker.sock: gets containers config
        acme_companion->>acme_companion: get certs to issue/renew
        acme_companion->>volumes: writes acme<br/>challenge files
        acme_companion->>acme_companion: signs certificates
        acme_companion->>volumes: writes cert files
        acme_companion->>docker.sock:  Signal HUP docker_gen_public<br/>(reload)
      end
    end
  and docker_gen_public
    rect rgb(128, 128, 32)
      loop on every notification
        alt signal
          docker.sock-)docker_gen_public: notifies Signal HUP<br/>(reload)
        else event
          docker.sock-)docker_gen_public: notifies new container<br/>"Your app"
        end
        docker_gen_public<<->>docker.sock: gets containers config
        volumes-->>docker_gen_public: reads template
        volumes-->>docker_gen_public: reads vhost.d conf
        volumes-->>docker_gen_public: reads existing certs
        alt cert available
          docker_gen_public->>docker_gen_public: add full vhost<br/>- acme challenge<br/>- http to https redirect<br/>- ssl/tls configuration
        else cert not found
          docker_gen_public->>docker_gen_public: add partial vhost<br/>- acme challenge
        end
        docker_gen_public->>volumes: writes nginx<br/>config file
        docker_gen_public->>docker.sock: Signal HUP ingress_public<br/>(reload)
      end
    end
  end
```

# Dual Ingress instances

```mermaid
sequenceDiagram
  participant docker.sock@{ "type" : "entity" }
  participant signal_propagator
  participant ingress_*@{ "type" : "collections" }
  participant acme_companion
  participant docker_gen_*@{ "type" : "collections" }
  participant volumes@{ "type" : "collections" }

  par signal-propagator
    rect rgb(32,32,128)
      loop on every notification
        docker.sock-)signal_propagator: notifies Signal HUP<br/>(reload)
        signal_propagator<<->>docker.sock:  get container ids<br/>matching filter label
        Note right of signal_propagator: container ids belogs to<br/>docker_gen_public and<br/>docker_gen_private<br/>instances
        loop Every container id
          signal_propagator->>docker.sock:  Signal HUP container id<br/>(reload)
        end
      end
    end
  and ingress_public]<br/>[ingress_private
    rect rgb(32,128,64)
      loop on every notification
        docker.sock-)ingress_*: notifies Signal HUP<br/>(reload)
        volumes-->>ingress_*: reads < instance >'s<br/>config
        ingress_*->>ingress_*: reload config
      end
    end
  and acme_companion
    rect rgb(128,64,64)
      loop on every notification and every hour
        docker.sock-)acme_companion: notifies new container<br/>"Your app"
        acme_companion<<->>docker.sock: gets containers config
        acme_companion->>acme_companion: get certs to issue/renew
        acme_companion->>volumes: writes acme<br/>challenge files
        acme_companion->>acme_companion: signs certificates
        acme_companion->>volumes: writes cert files
        acme_companion-)docker.sock:  Signal HUP signal_propagator<br/>(reload)
        
      end
    end
  and docker_gen_public]<br/>[docker_gen_private
    rect rgb(128, 128, 32)
      loop on every notification
        alt signal
          docker.sock-)docker_gen_*: notifies Signal HUP<br/>(reload)
        else event
          docker.sock-)docker_gen_*: notifies new container<br/>"Your app"
        end
        docker_gen_*<<->>docker.sock: gets < instance >'s containers config
        volumes-->>docker_gen_*: reads < instance >'s<br/>template
        volumes-->>docker_gen_*: reads < instance >'s<br/>vhost.d conf
        volumes-->>docker_gen_*: reads existing certs
        alt cert available
          docker_gen_*->>docker_gen_*: add full vhost<br/>- acme challenge<br/>- http to https redirect<br/>- ssl/tls configuration
        else cert not found
          docker_gen_*->>docker_gen_*: add partial vhost<br/>- acme challenge
        end
        docker_gen_*->>volumes: writes < instance >'s<br/>nginx config file
        docker_gen_*->>docker.sock: Signal HUP ingress_< instance ><br/>(reload)
      end
    end
  end
```
