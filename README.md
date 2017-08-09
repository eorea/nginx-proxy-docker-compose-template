# nginx-proxy-docker-compose-template

Nginx proxy's docker compose template, with Let's Encrypt support.

## Getting started

### Certs

Review the information contained in this [file](nginx-proxy-volume/certs/README.md) regarding the creation of DH parameters file and importing existing certificates.

### Docker volume

In order for your certificates to be stored persistently you need to use docker volume as follow.

Copy or move `nginx-proxy-volume` to your prefered docker volume path.

Update the volume paths in `docker-compose.yml`.

#### Use sed to update volume paths

##### MacOS

```
sed -i '' 's#/your/path/#/Users/eorea/#' docker-compose.yml
```

##### Linux

```
sed -i 's#/your/path/#/home/eorea/#' docker-compose.yml
```

### Customize your-app service definition

Within `docker-compose.yml` you will find a sample of application for which nginx will auto configure its proxy, and for which SSL certificates are going to be created using Let's Encrypt.

You need to define the following variables in `docker-compose.yml` for this to work.

| Variable | Description |
| --- | --- |
| VIRTUAL_HOST | Comma separated list of domain names that nginx proxy will forward requests from |
| VIRTUAL_PORT | If container publishes several ports, this specify the port which nginx proxy is going to forward the requests to |
| LETSENCRYPT_HOST | Comma separated list of domain names for SSL certificate. If multiple domains are specified the first one becomes the CN (Common Name) of the certificate and the rest become the SAN (Subject Alternative Names) |
| LETSENCRYPT_EMAIL | Email address for SSL certificate registration |

