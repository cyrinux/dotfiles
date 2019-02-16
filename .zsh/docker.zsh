alias dr="sudo docker run --rm -it"
alias di="sudo docker images | head -n 1 && sudo docker images | tail -n +2 | sort"
alias dps="sudo docker ps -a"
alias drm="sudo docker rm"
alias drmi="sudo docker rmi"
alias drmcd='sudo drm $(dps -q -f status=exited -f status=created)'
alias drmvd='sudo docker volume rm $(sudo docker volume ls -q -f dangling=true)'
alias drmid='sudo drmi $(sudo docker images -q -f dangling=true)'
# alias drmid="docker images -q -f dangling=true | tr '\n' ' ' | xargs docker rmi -f && \
#     docker images | grep \"^<none>\" | awk \"{print $3}\" | tr '\n' ' ' | tr '\n' ' ' | xargs docker rmi -f"
alias dpurge="drmcd ; drmvd ; drmid ;sudo docker network prune -f"
alias dc="sudo docker-compose"

function dockershellhere() {  
    dirname=${PWD##*/}
    sudo docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {  
    dirname=${PWD##*/}
    sudo docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}


alias fedora="sudo docker run --rm -it fedora"
alias ubuntu="sudo docker run --rm -it ubuntu"
alias centos="sudo docker run --rm -it centos"
