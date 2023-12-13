FROM centos:7
# Java 1.8
# Tomcat 7

RUN yum install -y epel-release
RUN yum update -y
RUN yum install -y java-1.8.0-openjdk httpd mod_ssl redis
RUN yum install -y wget gcc gcc-c++ httpd-devel

RUN yum install -y net-tools

RUN wget --no-check-certificate https://dlcdn.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.48-src.tar.gz
RUN tar vxzf tomcat-connectors-1.2.48-src.tar.gz

WORKDIR '/tomcat-connectors-1.2.48-src/native'
RUN ./configure --with-apxs=/usr/bin/apxs
RUN make
RUN make install
WORKDIR '/'

RUN yum remove -y wget gcc gcc-c++ httpd-devel
RUN yum clean all

RUN useradd opc

ADD resources/httpd/conf /etc/httpd/conf
ADD resources/httpd/conf.d /etc/httpd/conf.d
ADD resources/httpd/conf.modules.d /etc/httpd/conf.modules.d
ADD resources/html /var/www/html
ADD resources/certs /home/opc/certs
ADD resources/app /app
RUN mkdir -p /data/O4OPJT/upload/id1/image/favicon
ADD resources/favicon.ico /data/O4OPJT/upload/id1/image/favicon/favicon.ico
RUN chmod -R 777 /data/O4OPJT

ADD resources/ext_conf /data/O4OPJT/ext_conf
RUN chown -R opc:opc /data/O4OPJT/ext_conf

RUN chown -R opc:opc /home/opc/certs
RUN chmod ag+rw /home/opc/certs

RUN mkdir -p /data/O4OPJT/admin/ROOT
RUN mkdir -p /data/O4OPJT/front/ROOT
RUN mkdir -p /data/O4OPJT/kiosk/ROOT
RUN mkdir -p /data/O4OPJT/kiosk/ROOT
RUN mkdir -p /data/O4OPJT/front/ROOT/WEB-INF/views/site/id1/__SKIN
RUN mkdir -p /data/O4OPJT/front/ROOT/WEB-INF/views/site/id1/skins

RUN mkdir -p /var/www/html/m
RUN mkdir -p /data/O4OPJT/mfront/m/WEB-INF/views/site/id1/__MSKIN
RUN mkdir -p /data/O4OPJT/mfront/m/WEB-INF/views/site/id1/skins

RUN ln -s /data/O4OPJT/admin/ROOT /var/www/html/admin
RUN ln -s /data/O4OPJT/front/ROOT /var/www/html/front
RUN ln -s /data/O4OPJT/kiosk/ROOT /var/www/html/kiosk
RUN ln -s /data/O4OPJT/front/ROOT/WEB-INF/views/site/id1/__SKIN /var/www/html/skin
RUN ln -s /data/O4OPJT/front/ROOT/WEB-INF/views/site/id1/skins /var/www/html/skins

RUN ln -s /data/O4OPJT/kiosk/ROOT /var/www/html/m/front
RUN ln -s /data/O4OPJT/mfront/m/WEB-INF/views/site/id1/__MSKIN /var/www/html/m/skin
RUN ln -s /data/O4OPJT/mfront/m/WEB-INF/views/site/id1/skins /var/www/html/m/skins

ADD entrypoint.sh entrypoint.sh
RUN chmod a+x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
