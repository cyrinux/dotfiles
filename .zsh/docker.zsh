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
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f --tail=1000'
alias dclp='docker-compose pull'
alias dcr='dcd; dcu'
alias dcr='docker-compose restart'
alias dcs='dc ps'
alias dc="sudo docker-compose"
alias dcu='docker-compose up'

alias fedora="sudo docker run --rm -it fedora"
alias ubuntu="sudo docker run --rm -it ubuntu"
alias centos="sudo docker run --rm -it centos"
alias trusty="sudo docker run --rm -it ubuntu:trusty"
alias bionic="sudo docker run --rm -it ubuntu:bionic"
alias xenial="sudo docker run --rm -it ubuntu:xenial"
alias focal="sudo docker run --rm -it ubuntu:focal"

alias java10-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:10-jdk"
alias java9-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:9-jdk"
alias java8-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:8-jdk"
alias javaws="docker run -ti --rm -e DISPLAY=$DISPLAY -e HOSTNAME=$HOSTNAME -v /tmp/.X11-unix:/tmp/.X11-unix xnaveira/docker-javaws bash"

function dockershellhere() {
    dirname=${PWD##*/}
    sudo docker run --rm -it --entrypoint=/bin/bash -v $(pwd):/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    sudo docker run --rm -it --entrypoint=/bin/sh -v $(pwd):/${dirname} -w /${dirname} "$@"
}
