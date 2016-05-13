FROM debian:jessie
MAINTAINER LolHens <pierrekisters@gmail.com>


COPY ["scripts/cleanimage", "/usr/local/bin/"]
RUN chmod +x "/usr/local/bin/cleanimage"

RUN apt-get update \
 && apt-get -y install \
      nano \
      runit \
      unzip \
      wget \
 && cleanimage

RUN wget -O /tmp/tini https://github.com/krallin/tini/releases/download/v0.9.0/tini \
 && chmod +x /tmp/tini \
 && mv /tmp/tini /usr/local/bin/

COPY ["scripts/my_init", "/usr/local/bin/"]
RUN chmod +x "/usr/local/bin/my_init" \
 && mkdir "/etc/my_init.d"

COPY ["scripts/appfolders", "/usr/local/bin/"]
RUN chmod +x "/usr/local/bin/appfolders" \
 && echo "appfolders link" > "/etc/my_init.d/link_appfolders" \
 && chmod +x "/etc/my_init.d/link_appfolders"

RUN cleanimage


ENTRYPOINT ["tini", "-g", "--", "my_init"]


VOLUME ["/usr/local/appdata"]
