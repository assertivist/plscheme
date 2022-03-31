FROM postgres:13
RUN apt-get update

RUN apt-get install -y \
    postgresql-server-dev-13 \
    build-essential \
    guile-3.0-dev \
    guile-3.0-libs

WORKDIR /usr/src/plscheme

COPY . ./

RUN ./install.sh

RUN echo " \
CREATE EXTENSION plschemeu; \
" >  /docker-entrypoint-initdb.d/init.sql