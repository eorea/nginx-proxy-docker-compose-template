# Docker compose

To run this project you can execute the default docker compose command, this will implicitly start a single ingress instance without volumes, as it implicitly loads `docker-compose.yml` alone.

```shell
docker compose <COMMAND>
```

## Start

To start the project use `up -d` command:

```shell
docker compose up -d
```

## Stop

To stop the project use `down` command:

```shell
docker compose down
```

## Decoupled docker compose files

This project uses multiple docker-compose files to support multiple scenarios and avoiding repeating code.

File | Purpose
--- | ---
docker-compose.yml | Starts the basic services with a single ingress instance
docker-compose.private.yml | Contains the added services to support a second ingress instance
docker-compose.services.yml | Contains 3 sample services to demonstrate the use of the two ingress instances
docker-compose.volumes.yml | Contains the change in configuration to use docker volumes for certs, acme and html for a single ingress instance
docker-compose.volumes.private.yml | Contains the change in configuration to use docker volumes for certs, acme and html for a the second ingress instance

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

### Dual ingress instances using volumes

To switch from bind mount point to docker volumes in a dual ingress scenario load also both `docker-compose.volumes.yaml` and `docker-compose.volumes.private.yml` files.


```shell
docker compose -f docker-compose.yml -f docker-compose.private.yml -f docker-compose.volumes.yml -f docker-compose.volumes.private.yml <COMMAND>
```

### Run your_*_app samples

After updating the environment variable values in `docker-compose.services.yml` file, you launch this containers by adding the compose file to your docker compose command ussing the `-f` argument:

```shell
docker compose -f docker-compose.yml -f docker-compose.private.yml -f docker-compose.volumes.yml -f docker-compose.volumes.private.yml -f docker-compose.services.yml <COMMAND>
```
