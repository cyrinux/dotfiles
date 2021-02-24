FROM archlinux:latest

WORKDIR /tmp/
RUN curl -O https://blackarch.org/strap.sh
RUN chmod +x strap.sh
RUN ./strap.sh

WORKDIR /root/
RUN echo '[multilib]' >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

RUN pacman -Syy --noconfirm \
    sudo \
	base \
	base-devel \
	zip \
	unrar \
	sslsplit \
	sqlmap \
	john \
	hydra \
	zsh \
	git \
	wget \
	kakoune \
	gdb \
    yay \
	python \
	python-pywinrm \
	python-pip \
	python2 \
	python2-pip \
	rpcbind \
	binutils \
	openssl \
	libffi \
	mlocate \
	nmap \
	nikto \
	openssh \
	sshpass \
	samba \
	smbclient \
	openldap \
    amass \
	binwalk \
	dirb \
    dnsx \
	enum4linux \
	evil-winrm \
	gnu-netcat \
	gobuster \
    httpx \
    masscan \
	metasploit \
	mitmproxy \
    naabu \
	padbuster \
    proxify \
    seclists \
    shuffledns \
	steghide \
	stegsolve \
    subfinder \
	wfuzz \
    wpscan

RUN useradd -m -r -s /bin/bash aur && \
    passwd -d aur && \
    echo 'aur ALL=(ALL) ALL' > /etc/sudoers.d/aur && \
    mkdir -p /home/aur/.gnupg && \
    echo 'standard-resolver' > /home/aur/.gnupg/dirmngr.conf && \
    chown -R aur:aur /home/aur && \
    mkdir /build && \
    chown -R aur:aur /build

RUN sudo -u aur yay --noconfirm -S feroxbuster-git

RUN wget https://raw.githubusercontent.com/evyatarmeged/stegextract/master/stegextract -O /usr/bin/stegextract \
	&& chmod +x /usr/bin/stegextract

RUN git clone https://github.com/teknogeek/fresh.py.git /opt/fresh.py

RUN pip install impacket stegcracker shodan BeautifulSoup4 -U --force-reinstall

RUN wget https://raw.githubusercontent.com/samba-team/samba/master/examples/smb.conf.default -O /etc/samba/smb.conf

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY .zshrc /root/
CMD ["/bin/zsh"]
