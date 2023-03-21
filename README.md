# docker-development-setup

Bundled:
- PHP versions: 5.6, 7.0, 7.1, 7.2, 7.3, 7.4, 8.0, 8.1, 8.2 (fpm edition)
  - Default version 7.4
- Nginx 1.22.1
- mysql 8.0.32
- redis 7.0.9


## Usage

Build with:
```
docker compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g)
```

Run with `docker compose up -d`. Everything starts automatically.

Useful aliases are in `aliases.sh`. Source them in your bashrc/zshrc.

### TLS

Before running, make sure to generate the TLS certificates and store them in a `/private/ssl` directory.

## Architecture

This repository should be cloned in `/private` on your device. All the projects *should* be cloned in `/private/var/www`.

Main components are:
- `devcontainer` - ubuntu container with nginx and all php versions bundled together
  - `supervisord` which starts all the daemon processes
- `mysql` as a db
- `redis` as a key value store


### Future work

- a local mail client
- improving node version management
