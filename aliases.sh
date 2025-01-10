project_path() {
    pwd -P | awk '{split($0, path, "websites/"); print path[2]}';
}
docker_project_path() {
    echo "/private/var/www/$(project_path)";
}

alias ddcompose="docker compose -f ~/docker-development-setup/docker-compose.yaml"
alias ddrebuild="ddcompose down && ddcompose build && ddcompose up -d"
alias ddrebuild-cache="ddcompose down && ddcompose build --no-cache && ddcompose up -d"

alias ddbash="ddcompose exec -it devcontainer bash"
alias ddproject='ddcompose exec -it -w $(docker_project_path) devcontainer'

for i in 56 70 71 72 73 74 81 82; do
    version="${i:0:1}.${i:1}";
    # php71
    alias php$i="ddproject /usr/bin/php$version";
    alias php$version="ddproject /usr/bin/php$version";
    # composer711
    alias composer${i}1="ddproject /usr/bin/php$version /usr/local/bin/composer1";
    # composer712
    alias composer${i}2="ddproject /usr/bin/php$version /usr/local/bin/composer2";
    # console71
    alias console$i="ddproject /usr/bin/php$version bin/console";
done

dep() {
    ddproject bash -ic "dep $@";
}

nvm() {
    ddproject bash -ic "nvm $@";
}
yarn() {
    ddproject bash -ic "nvm use && yarn $@";
}
pnpm() {
    ddproject bash -ic "nvm use && pnpm $@";
}
grunt() {
    ddproject bash -ic "nvm use && grunt $@";
}
npm() {
    ddproject bash -ic "nvm use && npm $@";
}
