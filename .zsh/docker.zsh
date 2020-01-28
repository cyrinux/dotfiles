#!/usr/bin/env zsh

alias dr="sudo docker run --rm -it"
alias di="sudo docker images | head -n 1 && sudo docker images | tail -n +2 | sort"
alias dps="sudo docker ps -a"
alias drm="sudo docker rm"
alias drmi="sudo docker rmi"
alias drmcd='sudo drm $(dps -q -f status=exited -f status=created)'
alias drmvd='sudo docker volume rm $(sudo docker volume ls -q -f dangling=true)'
alias drmid='sudo drmi $(sudo docker images -q -f dangling=true)'
alias dpurge="drmcd ; drmvd ; drmid ;sudo docker network prune -f"

alias docker-compose='sudo docker-compose'
alias dc="sudo docker-compose"
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcl='docker-compose logs -f'
alias dclp='docker-compose pull'

alias fedora="sudo docker run --rm -it fedora"
alias ubuntu="sudo docker run --rm -it ubuntu"
alias centos="sudo docker run --rm -it centos"
alias trusty="sudo docker run --rm -it ubuntu:trusty"
alias bionic="sudo docker run --rm -it ubuntu:bionic"
alias xenial="sudo docker run --rm -it ubuntu:xenial"

alias java10-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:10-jd"
alias java9-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:9-jdk"
alias java8-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:8-jdk"

function dockershellhere() {
    dirname=${PWD##*/}
    sudo docker run --rm -it --entrypoint=/bin/bash -v $(pwd):/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    sudo docker run --rm -it --entrypoint=/bin/sh -v $(pwd):/${dirname} -w /${dirname} "$@"
}
