# nginx-proxy-docker-compose-template

Nginx proxy's docker compose template, with ACME (Let's Encrypt) support.

## How it works

```text
            +------------+
            | docker-gen |--> (1) writes nginx config file when container are
            +------------+    added, removed, stoped, started
                  |
           (2) HUP (reload)
                  |
                  V
+------+     +---------+     +----------+
| User | --> | Ingress | --> | Your App |
+------+     +---------+     +----------+
                  ^
                  |
           (4) HUP (reload)
                  |
          +----------------+
          | acme-companion |--> (3) creates ACME challenges for new containers
          +----------------+    and triggers provider to validate and sign certs
```

## Getting started

Create your own `.env` file based on the content of `dotenv.sample` file.

Set your local environment by sourcing any of the setenv scripts, depending on your environment.

# MacOS and Linux sourcing

Bash and zsh shells supports the following syntax: 

```shell
source ./setenv.sh
```

If you want to source a `.env.<environment>` file, like `.env.dev` use:

```shell
source ./setenv.sh .env.dev
```

# Powershell sourcing

```shell
. ./setenv.ps1
```

If you want to source a `.env.<environment>` file, like `.env.dev` use:

```shell
. ./setenv.ps1 .env.dev
```

### Programatically populate environment variables

#### MacOS

```shell
cp dotenv.sample .env
sed -i '' 's#/your/project/path/#/Users/eorea/#' .env
```

#### Linux

```shell
cp dotenv.sample .env
sed -i 's#/your/project/path/#/home/eorea/#' .env
```

### Certs

Review the information contained in this [file](nginx-proxy-volume/certs/README.md) regarding the creation of DH parameters file and importing existing certificates.

### Docker volume

In order for your certificates to be stored persistently you need to use docker volume as follow.

Copy or move `nginx-proxy-volume` to your prefered docker volume path.

Update the volume paths in `.env`.

### Customize your-app service definition

Within `docker-compose.yml` you will find a sample of application for which nginx will auto configure its proxy, and for which SSL certificates are going to be created using Let's Encrypt.

You need to define the following variables in `docker-compose.yml` for this to work.

| Variable | Description |
| --- | --- |
| VIRTUAL_HOST | Comma separated list of domain names that nginx proxy will forward requests from |
| VIRTUAL_PORT | If container publishes several ports, this specify the port which nginx proxy is going to forward the requests to |
| LETSENCRYPT_HOST | Comma separated list of domain names for SSL certificate. If multiple domains are specified the first one becomes the CN (Common Name) of the certificate and the rest become the SAN (Subject Alternative Names) |
| LETSENCRYPT_EMAIL | Email address for SSL certificate registration |

### Running docker compose

To run this project you can execute the default docker compose command, this will implicitly start a single ingress instance without volumes, as it implicitly loads `docker-compose.yml` alone.

```shell
docker compose <COMMAND>
```

#### Start

To start the project use `up -d` command:

```shell
docker compose up -d
```

#### Stop

To stop the project use `down` command:

```shell
docker compose down
```

### Single ingress instance

To explicitly run a single ingress instance use the following command:

```shell
docker compose -f docker-compose.yml <COMMAND>
```

### Single ingress instance using volumes

To switch from bind mount point to docker volumes load also the `docker-compose.volumes.yaml` file.

```shell
docker compose -f docker-compose.yml -f docker-compose.volumes.yml <COMMAND>
```

### Dual ingress instances

For an scenario where you want to have a public ingress nginx instance and one private, you need to explicitly pass both `docker-compose.private.yml` and `docker-compose.private.yml` files to the docker compose command.

```shell
docker compose -f docker-compose.yml -f docker-compose.private.yml <COMMAND>
```

### Dual ingress instance using volumes

To switch from bind mount point to docker volumes in a dual ingress scenario load also both `docker-compose.volumes.yaml` and `docker-compose.volumes.private.yml` files.


```shell
docker compose -f docker-compose.yml -f docker-compose.private.yml -f docker-compose.volumes.yml -f docker-compose.volumes.private.yml <COMMAND>
```
