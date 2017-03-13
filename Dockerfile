FROM debian:jessie
  RUN awk '$1 ~ "^deb" { $3 = $3 "-backports"; print; exit }' /etc/apt/sources.list > /etc/apt/sources.list.d/backports.list
  RUN apt-get update && apt-get install -y apt-utils wget rsync locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
    ENV LANG en_US.utf8
  RUN apt-get update \
  ## Add dotdeb Repo
  && echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
  && echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
  && echo 'deb http://packages.dotdeb.org jessie-nginx-http2 all' >> /etc/apt/sources.list \
  && echo 'deb-src http://packages.dotdeb.org jessie-nginx-http2 all' >> /etc/apt/sources.list \
  && wget https://www.dotdeb.org/dotdeb.gpg \
  && apt-key add dotdeb.gpg \
  && apt-get update \
  ## Install openssl from backports
  && apt-get -t jessie-backports install "openssl" -y \
  ## Install nginx-extras from dotdeb
  && apt-get install -y nginx-extras -y \
  ## Install Git
  && apt-get install -y git
  ## Update custom nginx configuration from Templates
  COPY nginx/ /etc/nginx/
