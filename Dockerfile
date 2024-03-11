FROM ubuntu:latest

COPY archives /archives

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update \
  && apt install nano -y \
  && apt install wget -y \
  && apt install libboost-dev -y \
  && apt install php-dev -y \
  && apt install libxml2-dev -y;

RUN tar xvf /archives/linux-amd64_deb.tgz \
  && cd /linux-amd64_deb \
  && ./install.sh \
  && apt install ./lsb-cprocsp-devel*.deb;

RUN tar xvf /archives/cades-linux-amd64.tar.gz \
  && cd /cades-linux-amd64 \
  && dpkg -i \
    cprocsp-pki-cades-64_2.0.14892-1_amd64.deb \
    cprocsp-pki-phpcades_2.0.14892-1_all.deb;


RUN tar xvf /archives/php-8.2.16.tar.gz;
RUN mv /php-8.2.16 /php;


RUN cp /archives/php8_support.patch /opt/cprocsp/src/phpcades/;

RUN cd /opt/cprocsp/src/phpcades \
  && patch -p0 < ./php8_support.patch \
  && eval `/opt/cprocsp/src/doxygen/CSP/../setenv.sh --64`; make -f Makefile.unix;


WORKDIR /




#CMD [ "php", "test.php" ]