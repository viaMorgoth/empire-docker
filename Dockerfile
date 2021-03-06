FROM kalilinux/kali-linux-docker
MAINTAINER @JamesHovious
# Setup OS repos
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean && apt-get -y update
RUN apt-get -y install python git python-pip libssl-dev libffi-dev python-dev python-m2crypto swig lsb-release curl wget
RUN pip install pyopenssl
# Create the empire workspace
RUN mkdir /root/empire
ADD start_empire.sh /root/
# Download the latest release version from GitHub
RUN wget `curl -s https://api.github.com/repos/EmpireProject/Empire/releases | grep tarball_url | head -n 1 | cut -d '"' -f 4` -O /root/empire.tar
RUN tar zxvf /root/empire.tar --strip-components=1 -C /root/empire
ENV STAGING_KEY=$RANDOM
RUN bash -c "cd /root/empire/setup && /root/empire/setup/install.sh"
RUN chmod +x /root/start_empire.sh
# Run the startup script
CMD ["/root/start_empire.sh"]
