# docker-development-setup

Bundled:
- PHP versions: 5.6, 7.0, 7.1, 7.2, 7.3, 7.4, 8.0, 8.1, 8.2 (fpm edition)
  - Default version 7.4
  - Extensions:
    - bcmath
    - curl
    - exif
    - fpm
    - gd
    - iconv
    - imagick
    - intl
    - mbstring
    - memcached
    - mysqli
    - opcache
    - redis
    - sockets
    - sqlite3
    - xml
    - xsl
    - zip
- Nginx 1.22.1
- mysql 8.0.32
- redis 7.0.9


## Usage

Build with:
```
docker compose build
```

Run with `docker compose up -d`. Everything starts automatically.

Useful aliases are in `aliases.sh`. Source them in your bashrc/zshrc.

### TLS

Before running, make sure to generate the TLS certificates and store them in a `/private/ssl` directory. The instructions are provided [here](https://docs.netgen.io/projects/lds/en/latest/ubuntu/ssl.html).

## Architecture

This project implements a common web development practice of having a development Docker container with everything preinstalled.

This repository should be cloned in `/private` on your device. All the projects *should* be cloned in `/private/var/www`.

Main components are:
- `devcontainer` - ubuntu container with nginx and all php versions bundled together
  - `supervisord` which starts all the daemon processes
- `mysql` as a db
- `redis` as a key value store

All commands related to PHP and JavaScript are imagined to be ran inside a development container. This means all invocations of composer, npm, yarn, nvm etc should *not* be invoked on the development machine but in the container (still typed in the terminal though).

`devcontainer` container is supposed to be the single contact point between the host (your laptop device) and the setup. `devcontainer` communicates with other containers (`mysql`, `redis`) via a [Docker network](https://docs.docker.com/network/). At the moment there are two docker networks: `redis-network`, connecting the `devcontainer` and the `redis` container, and the `mysql-network` connecting the `devcontainer` and `mysql`.

To save a programmer from having to manage all the containers manually, this whole stack is deployed with `docker compose`. It manages the Docker network, Docker volumes for storage, Docker network and all the containers.


# Possible issues and/or suggestions
Writing from a container to a host (your laptop device) _may introduce troubles_ because the permissions will likely be `root:root` which you don't really want. The current suggestion is to have `rwsr-sr-s` permissions set on the parent folder of the docker-development-setup (at the moment that is `/private`).
NVM stores node versions in `/root/.nvm/.cache`. It may be worthwhile to store this cache in a Docker volume persist the download cache between container restarts (e.g. shutting down your laptop device).



## Future work

- write guides for migration from local-development-setup to docker-development-setup
- a local mail client
- a database client
- (as is always) thorough testing
