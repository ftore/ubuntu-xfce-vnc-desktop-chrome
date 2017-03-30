FROM ubuntu:16.04

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install -y supervisor wget \
		xfce4 xfce4-goodies x11vnc xvfb \
		gconf-service libnspr4 libnss3 fonts-liberation \
		libappindicator1 libcurl3 fonts-wqy-microhei

RUN apt-get install -y libpango1.0-0

# download google chrome and install
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --no-check-certificate
RUN dpkg -i google-chrome*.deb
RUN apt-get install -f

RUN apt-get install -y maven

RUN apt-get install -y software-properties-common
RUN apt-get install -y python-software-properties debconf-utils

RUN \
  add-apt-repository ppa:webupd8team/java && \
  apt-get update && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  apt-get install -y oracle-java8-installer

RUN apt-get install -y git

RUN apt-get autoclean && apt-get autoremove && \
		rm -rf /var/lib/apt/lists/*

WORKDIR /root

ADD startup.sh ./
ADD supervisord.conf ./

# prepare chrome extension to install
ADD kcoilljlnfjahoofolooodhmgojcfnpo.json /opt/google/chrome/extensions/

# develop version chrome extension
#COPY ext ./ext

COPY xfce4 ./.config/xfce4

EXPOSE 5900

ENTRYPOINT ["./startup.sh"]
