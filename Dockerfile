FROM ubuntu:20.04

####################################################
## Build environment (for manual devving)         ##
####################################################

ENV TOOLCHAINDIR="/usr/src/arm-linux-3.3/toolchain_gnueabi-4.4.0_ARMv5TE/usr/bin"
ENV PATH="${TOOLCHAINDIR}:${PATH}:$HOME/.composer/vendor/mediamonks/composer-vendor-cleaner/bin"

ENV TARGET="arm-unknown-linux-uclibcgnueabi"

ENV AR="${TARGET}-ar"
ENV AS="${TARGET}-as"
ENV CC="${TARGET}-gcc"
ENV CXX="${TARGET}-g++"
ENV LD="${TARGET}-ld"
ENV NM="${TARGET}-nm"
ENV RANLIB="${TARGET}-ranlib"
ENV STRIP="${TARGET}-strip"

ENV TOPDIR="/env"
ENV SOURCEDIR="${TOPDIR}/src"
ENV PREFIXDIR="${TOPDIR}/prefix"
ENV BUILDDIR="${TOPDIR}/build"

ENV INSTALLDIR="${TOPDIR}/sdcard/firmware/bin"
ENV WEBROOT="${TOPDIR}/sdcard/firmware/www"

ENV DEBIAN_FRONTEND=noninteractive

####################################################
## Install dependencies and requirements          ##
####################################################

RUN echo "*** Install required packages" \
 && apt-get -qq update       \
 && apt-get -qq install -y   \
      autoconf               \
      cmake                  \
      ca-certificates        \
      bison                  \
      build-essential        \
      composer               \
      cpio                   \
      curl                   \
      file                   \
      flex                   \
      gawk                   \
      gettext                \
      git                    \
      groff                  \
      jq                     \
      libtool                \
      lib32z1-dev            \
      libcurl4-openssl-dev   \
      libssl-dev             \
      libyaml-dev            \
      locales                \
      make                   \
      ncurses-dev            \
      openssl                \
      php-curl               \
      pkg-config             \
      python3                \
      python3-pip            \
      python3-dev            \
      rsync                  \
      texi2html              \
      texinfo                \
      tofrodos               \
      unrar                  \
      unzip                  \
      vim                    \
      wget                   \
      zip                    \
 && apt-get clean

####################################################
## Install python requirements                    ##
####################################################

COPY tests/requirements.txt /env/tests/requirements.txt
RUN pip3 install -r /env/tests/requirements.txt

####################################################
## Install composer requirments                   ##
####################################################

RUN echo "*** Installing composer requirements" \
 && composer global require hirak/prestissimo mediamonks/composer-vendor-cleaner

####################################################
## Download and unpack toolchain                  ##
####################################################

RUN echo "*** Downloading toolchain"     \
 && mkdir -p /usr/src/arm-linux-3.3      \
 && cd /tmp/ \
 && wget -O toolchain.tgz https://github.com/balves42/miicam_2022/raw/master/utils/toolchain_gnueabi-4.4.0_ARMv5TE.tgz
 


RUN echo "*** Unpacking Toolchain"       \
 && cd /usr/src/arm-linux-3.3            \
 && tar xzf /tmp/toolchain.tgz

####################################################
## Source utils in profile                        ##
####################################################

RUN echo "source /env/tools/dev/helpers.sh" >> /root/.bashrc

####################################################
## Configure locales                              ##
####################################################

RUN locale-gen en_US.UTF-8

####################################################
## Set workdir and copy files                     ##
####################################################

WORKDIR /env
COPY . .


####################################################
##                                                ##
####################################################
