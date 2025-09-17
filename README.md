# nginx-proxy-docker-compose-template

Nginx proxy's docker compose template, with ACME (Let's Encrypt) support.

## How it works

Read [How it works](docs/how-it-works.md) documentation.

## Getting started


Create your own `.env` file based on the content of `dotenv.sample` file.

Docker compose should load automatically the `.env` file, in case you see errors regarding `${variable}` not existing, then you may need to source the `.env` file before continuing.

### Source your .env file

Set your local environment by sourcing any of the setenv scripts, depending on your environment.

#### MacOS and Linux sourcing

Bash and zsh shells supports the following syntax: 

```shell
source ./setenv.sh
```

If you want to source a `.env.<environment>` file, like `.env.dev` use:

```shell
source ./setenv.sh .env.dev
```

#### Powershell sourcing

```shell
. ./setenv.ps1
```

If you want to source a `.env.<environment>` file, like `.env.dev` use:

```shell
. ./setenv.ps1 .env.dev
```

### Certs

Review the information contained in this [file](nginx_proxy_volumes/certs/README.md) regarding the creation of DH parameters file and importing existing certificates.

### Docker volumes

In order for your certificates to be stored persistently you need to use docker volume as follow.

Update the PROJECT_PATH variable in `.env` to reflect this project's absolute path.

### Customize your_*_app samples

Within `docker-compose.services.yml` you will find a set of sample applications for which nginx will auto configure its proxy, and for which SSL certificates are going to be created using Let's Encrypt though the acme_companion container.

You need to update the following variables in `docker-compose.services.yml` for this to work.

| Variable | Description |
| --- | --- |
| VIRTUAL_HOST | Comma separated list of domain names that nginx proxy will forward requests from |
| VIRTUAL_PORT | If container publishes several ports, this specify the port which nginx proxy is going to forward the requests to |
| LETSENCRYPT_HOST | Comma separated list of domain names for SSL certificate. If multiple domains are specified the first one becomes the CN (Common Name) of the certificate and the rest become the SAN (Subject Alternative Names) |
| LETSENCRYPT_EMAIL | Email address for SSL certificate registration |

### Running docker compose

Read [Docker compose](docs/compose.md) documentation.
