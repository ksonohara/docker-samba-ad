FROM sonohara/samba-base:samba-4.6
MAINTAINER Expert Software Inc. / https://www.e-software.company

LABEL name="Samba AD/DC" \
      vendor="ExpertSoftware Inc." \
      license="GPLv3" \
      build-date="20171119" \
      build-tag="1.0.0_0" \
      build-version="0"

#RUN sed -i 's@PEERDNS=yes@PEERDNS=no@g' /etc/sysconfig/network-scripts/ifcfg-ens3
#RUN sed -i 's@IPV6_PEERDNS=yes@IPV6_PEERDNS=no@g' /etc/sysconfig/network-scripts/ifcfg-ens3
#RUN sed -i 's@IPV6_AUTOCONF=yes@IPV6_AUTOCONF=no@g' /etc/sysconfig/network-scripts/ifcfg-ens3
#RUN echo DNS1=127.0.0.1 >> /etc/sysconfig/network-scripts/ifcfg-ens3

#RUN cat /etc/sysconfig/network-scripts/ifcfg-ens3

COPY config.txt /.docker/config
COPY smb-global.txt /.docker/smb-global.conf
COPY smb-share.txt /.docker/smb-share.conf

COPY init.sh /.docker/init.sh
COPY setup.sh /.docker/setup.sh
COPY service.sh /.docker/service.sh
RUN chmod 755 /.docker
RUN chmod 755 /.docker/*.sh

RUN yum uninstall -y wget rsync curl || true

ENV DNS_FORWARD 8.8.8.8
ENV DNS_DOMAIN sambaad.local
ENV AD_PASSWORD PASS0rd123
ENV AD_REALM sambaad.local
ENV AD_DOMAIN SAMBAAD
ENV AD_NOSTRONGAUTH 1
ENV AD_HOST_IP ""
ENV AD_OPTIONS ""

VOLUME ["/var/lib/samba", "/var/log/samba", "/etc/samba", "/.docker"]

EXPOSE 53 135 137/udp 138/udp 139 389 445 464 636

ENTRYPOINT ["/entrypoint.sh"]
