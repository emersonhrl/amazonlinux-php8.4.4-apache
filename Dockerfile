FROM amazonlinux:2023.6.20250218.2

RUN dnf update -y
RUN dnf install wget -y
RUN dnf install tar -y
RUN dnf install gzip -y
RUN dnf install gcc make autoconf automake libtool bison sqlite-devel libxml2-devel openssl-devel libcurl-devel libicu-devel libpng-devel oniguruma-devel -y

RUN dnf install pcre-devel -y

WORKDIR /

RUN wget https://dlcdn.apache.org/httpd/httpd-2.4.63.tar.gz
RUN tar -xvzf httpd-2.4.63.tar.gz

WORKDIR /httpd-2.4.63

RUN wget https://dlcdn.apache.org//apr/apr-1.7.5.tar.gz
RUN tar -xvzf apr-1.7.5.tar.gz
RUN mv apr-1.7.5 srclib/apr

RUN wget https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz
RUN tar -xvzf apr-util-1.6.3.tar.gz
RUN mv apr-util-1.6.3 srclib/apr-util

RUN dnf install gcc-c++ -y
RUN wget https://github.com/libexpat/libexpat/releases/download/R_2_6_4/expat-2.6.4.tar.gz
RUN tar -xvzf expat-2.6.4.tar.gz

WORKDIR /httpd-2.4.63/expat-2.6.4

RUN ./configure
RUN make
RUN make install

WORKDIR /httpd-2.4.63

RUN ./configure --enable-so --with-included-apr
RUN make
RUN make install

WORKDIR /

RUN wget https://www.php.net/distributions/php-8.4.4.tar.gz
RUN tar -xvzf php-8.4.4.tar.gz

WORKDIR /php-8.4.4

RUN ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-openssl --with-curl --with-libxml --with-mbstring --with-gd --with-zlib --with-sqlite3 --with-pdo-mysql
RUN make 
RUN make install
RUN cp php.ini-development /usr/local/lib/php.ini

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN /usr/local/apache2/bin/apachectl -f /usr/local/apache2/conf/httpd.conf

EXPOSE 80

ENTRYPOINT ["/usr/local/apache2/bin/apachectl", "-D", "FOREGROUND"]
