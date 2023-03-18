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
