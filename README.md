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
- mysql 8.0.40
- redis 7.0.9
- mailpit
- Solr 8.11.3

## Local machine preparation

### dnsmasq

You will need dnsmasq, so follow the LDS instructions to install and configure it.
- MacOS - https://docs.netgen.io/projects/lds/en/latest/macos/dnsmasq.html#install
- Linux - https://docs.netgen.io/projects/lds/en/latest/ubuntu/dnsmasq.html#install

### SSL

Before running, make sure to generate the TLS certificates and store them in the `ssl` directory in this repository.
You can follow the LDS instructions for that with the notes:
- use this repository's `ssl` directory instead of `~/ssl` in the given commands
- the `root.conf` and `server.conf` files are already provided in the `ssl` directory

- MacOs - https://docs.netgen.io/projects/lds/en/latest/macos/ssl.html
- Linux - https://docs.netgen.io/projects/lds/en/latest/ubuntu/ssl.html

### aliases

Useful aliases to use on your machine are in `aliases.sh`. Source them in your bashrc/zshrc, and check them out to know what you have available to use.

For use within the docker, there's the `shell/aliases.sh` file that's mounted into the container's `.bash_aliases`. Adapt it to your needs.

## Repository and projects location

This repository can be cloned wherever you wish on your machine. All the projects have to be cloned directly inside the prepared `websites` folder in the repository - everything in there will be gitignored, so no worries about that. They cannot be symlinks to cloned projects elsewhere! But...

For ease-of-access, you can always add a symlink to the `websites` folder elsewhere on your machine, e.g.
```
cd ~
ln -s path/to/docker-development-setup/websites www
```

## Usage

Build from the root of this repository with:
```
docker compose build
```

It might take a while.

When it's done, run it with `docker compose up -d`. Everything starts automatically.

## Architecture

This project implements a common web development practice of having a development Docker container with everything preinstalled.

Main components are:
- `devcontainer` - ubuntu container with nginx and all php versions bundled together
  - `supervisord` which starts all the daemon processes
- `mysql` as a db, exposed on port 3306 to access from tools like TablePlus
- `redis` as a key value store
- `solr` as a search engine, exposed on port 8983 to access the admin
- `mailpit` as a local smtp, exposed on port 8025 to access the UI

All commands related to PHP and JavaScript are imagined to be ran inside a development container. This means all invocations of composer, npm, yarn, nvm etc should *not* be invoked on the development machine but in the container (still typed in the terminal though). Some of the aliases include functions that execute the given commands inside the container, though, and can be used, as well.

`devcontainer` container is supposed to be the single contact point between the host (your laptop device) and the setup. `devcontainer` communicates with other containers (`mysql`, `redis`) via a [Docker network](https://docs.docker.com/network/). All used networks can be seen in `docker-compose.yaml` under the `networks` key for each image and in root near the bottom of the file.

To save a programmer from having to manage all the containers manually, this whole stack is deployed with `docker compose`. It manages the Docker network, Docker volumes for storage, Docker network and all the containers.

## Possible issues and/or suggestions
Writing from a container to a host (your laptop device) _may introduce troubles_ because the permissions will likely be `root:root` which you don't really want. **If that happens**, the current suggestion is to have `rwsr-sr-s` permissions set on the parent folder of the docker-development-setup (wherever you cloned it).

## Future work

- write guides for migration from local-development-setup to docker-development-setup
- expose Solr core configurations on the local machine
- add Elasticsearch
- add HAProxy
- vite CORS issues when watching files
- nginx access.log permission issues
- in general test logs
- macOS speed test
- make sure everything that should/could be persisted is persisted between builds
  - git config
  - ssh known hosts
  - global composer
- (as is always) thorough testing
