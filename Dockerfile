# Utilizando a release jessian do Debian como base
FROM debian:jessie

RUN apt-get update
RUN apt-get -y upgrade

# Instalando Apache2, o PHP 5.6 e as extensões necessárias
RUN apt-get -y install apache2 php5 libapache2-mod-php5 php5-dev php-pear php5-curl curl libaio1

# Instalando o Oracle Instant Client
ADD oracle-files/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /tmp
ADD oracle-files/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /tmp
ADD oracle-files/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb /tmp
RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb
RUN rm -rf /tmp/oracle-instantclient12.1-*.deb

# Setando variáveis de ambiente do Oracle
ENV LD_LIBRARY_PATH /usr/lib/oracle-files/12.1/client64/lib/
ENV ORACLE_HOME /usr/lib/oracle-files/12.1/client64/lib/

# Instalando a extensão OCI8 do PHP
RUN echo 'instantclient,/usr/lib/oracle-files/12.1/client64/lib' | pecl install -f oci8-2.0.8
RUN echo "extension=oci8.so" > /etc/php5/apache2/conf.d/30-oci8.ini

# Ativando módulos do Apache2
RUN a2enmod rewrite

# Setando variáveis de ambiente do Apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Executando o Apache2 em primeiro plano
CMD /usr/sbin/apache2 -D FOREGROUND