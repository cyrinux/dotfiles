FROM archlinux:latest

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

# WORKAROUND for systemd
# https://serverfault.com/questions/607769/running-systemd-inside-a-docker-container-arch-linux
STOPSIGNAL SIGRTMIN+3

# WORKAROUND for arch-secure-boot and systemd
ENV ESP="/tmp"

# Locales keyboard
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen \
 && echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
ENV LANG="en_US.UTF-8"

# Archlinux Deps
RUN yes y | pacman -Sy --noconfirm \
      sudo \
      binutils \
      util-linux \
      fakeroot \
      file \
      python \
      yajl \
      make \
      gcc \
      pkg-config \
      which \
      perl \
      automake \
      autoconf \
      gettext \
      patch \
      rsync \
      xorg-server-xephyr \
      git \
      arch-install-scripts

ENV PATH="${PATH}:/usr/bin/core_perl"
# Fix tmp dir perms
RUN chmod 1777 /tmp
# Create test user
RUN useradd -m cyril \
 && chown -R cyril:cyril /home/cyril \
 && echo -e "cyril\ncyril" | passwd cyril
RUN echo "cyril ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# gpg keys
RUN pacman-key --init && curl -s https://levis.name/pgp_keys.asc | pacman-key -a - && \
    pacman-key --lsign-key "0x6DB88737C11F5A48"

# install blackarch gpg keys
RUN curl -sL https://blackarch.org/strap.sh | bash

# pacman config
COPY archlinux/pacman.conf /etc/pacman.conf
RUN pacman -Sy

# User run
USER cyril
WORKDIR /home/cyril/.dotfiles
COPY . .
CMD ["/bin/bash"]
