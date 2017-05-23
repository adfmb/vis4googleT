FROM r-base:latest

MAINTAINER Alfredo Méndez <actuario.alfredo.mb@gmail.com>

ENV REFRESHED_AT 2017-045-21

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        libgdbm3 \
        libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

ENV GPG_KEY 97FC712E4C024BBEA48A61ED3A5CA953F73C700D
ENV PYTHON_VERSION 3.5.3

RUN set -ex \
    && buildDeps=' \
        dpkg-dev \
        gcc \
        libbz2-dev \
        libc6-dev \
        libgdbm-dev \
        liblzma-dev \
        libncurses-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        make \
        tcl-dev \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
    ' \
#    && apt-get install gpg \
 
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    \
    && wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
    && wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
#    && export GNUPGHOME="$(mktemp -d)" \
#    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
#    && gpg --batch --verify python.tar.xz.asc python.tar.xz \
#    && rm -r "$GNUPGHOME" python.tar.xz.asc \
    && mkdir -p /usr/src/python \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
    && rm python.tar.xz \
    \
    && cd /usr/src/python \
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && ./configure \
        --build="$gnuArch" \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
        --without-ensurepip \
    && make -j "$(nproc)" \
    && make install \
    && ldconfig \
    \
#    && apt-get purge -y --auto-remove $buildDeps \
#    \
    && find /usr/local -depth \
        \( \
            \( -type d -a -name test -o -name tests \) \
            -o \
            \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        \) -exec rm -rf '{}' + \
    && rm -rf /usr/src/python

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
    && ln -s idle3 idle \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 9.0.1

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends wget; \
    rm -rf /var/lib/apt/lists/*; \
    \
    wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
    \
#    apt-get purge -y --auto-remove wget; \
    \
    python get-pip.py \
        --disable-pip-version-check \
        --no-cache-dir \
        "pip==$PYTHON_PIP_VERSION" \
    ; \
    pip --version; \
    \
    find /usr/local -depth \
        \( \
            \( -type d -a -name test -o -name tests \) \
            -o \
            \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        \) -exec rm -rf '{}' +; \
    rm -f get-pip.py

RUN \
    apt-get -qq update; apt-get upgrade -y -qq; \
    apt-get install -y --no-install-recommends -qq wget curl git locales bzip2 unzip xz-utils build-essential; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Arreglamos el LOCALE
RUN echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen es_MX.utf8 \
    && /usr/sbin/update-locale LANG="es_MX.UTF-8 UTF-8" \
    && dpkg-reconfigure locales


RUN apt-get update \
    && apt-get install -y liblapack-dev libblas-dev gfortran \
                       libpq-dev \
                       make libssl-dev zlib1g-dev \
                       libbz2-dev libreadline-dev libsqlite3-dev llvm \
                       libncurses5-dev libncursesw5-dev xz-utils \ 
# libpng12-dev 
                       libfreetype6-dev libfreetype6 libxft-dev freetype* \
                       libmysqlclient-dev


## Requerimientos
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

##### La parte de R


RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev \
    unzip


# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny','shinydashboard','RCurl','ggplot2','rmarkdown'), repos='http://cran.rstudio.com/')"

COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY ../* /srv/shiny-server/

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
