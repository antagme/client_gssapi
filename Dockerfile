FROM fedora
MAINTAINER "Antonia Aguado Mercado" <nomail@gmail.com> 

#installs
RUN dnf install -y procps openldap openldap-clients krb5-workstation cyrus-sasl-gssapi cyrus-sasl-ldap nss-pam-ldapd supervisor pam_krb5 sssd sssd-client authconfig zabbix-agent ; exit 0
# directoris
RUN mkdir /opt/docker
RUN mkdir /var/tmp/home
RUN mkdir /var/tmp/home/1asix
RUN mkdir /var/tmp/home/2asix
#Copy github to dockerhub build
COPY scripts /scripts/
COPY files /opt/docker
RUN cp -f /opt/docker/sssd.conf /etc/sssd/
RUN chmod 600 /etc/sssd/sssd.conf
RUN cp -f /opt/docker/authconfig /etc/sysconfig/
RUN cp -f /opt/docker/krb5.conf /etc/
RUN authconfig --update
RUN cp -f /opt/docker/pam.d/* /etc/pam.d/
RUN cp /opt/docker/supervisord.ini /etc/supervisord.d/
RUN cp /opt/docker/ns* /etc/
RUN cp -f /opt/docker/ldap.conf /etc/openldap/
RUN cp -f /opt/docker/zabbix_agentd.conf /etc/
#Copying tls files for SSL
RUN cp /opt/docker/ldapcert.pem /etc/openldap/certs/
RUN cp /opt/docker/ldapserver.pem /etc/openldap/certs/
RUN cp /opt/docker/cacert.pem /etc/ssl/certs/
RUN chmod 400 /etc/openldap/certs/ldapserver.pem
#COPY configs /etc/
#VOLUME ["/data"] 
ENTRYPOINT ["/bin/bash","/scripts/entrypoint.sh"]
#EXPOSE 25 143 587 993 4190 8001 8002 
