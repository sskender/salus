FROM ubuntu:16.04

RUN apt-get update -y
RUN apt-get install debconf apt-utils -y
RUN apt-get install curl g++-aarch64-linux-gnu g++-4.8-aarch64-linux-gnu gcc-4.8-aarch64-linux-gnu binutils-aarch64-linux-gnu g++-arm-linux-gnueabihf g++-4.8-arm-linux-gnueabihf gcc-4.8-arm-linux-gnueabihf binutils-arm-linux-gnueabihf g++-4.8-multilib gcc-4.8-multilib binutils-gold bsdmainutils -y
RUN apt-get install build-essential g++ python-dev -y
RUN apt-get install autotools-dev -y
RUN apt-get install automake -y
RUN apt-get install libtool pkg-config -y
RUN apt-get install wget -y
RUN apt-get install libevent-dev -y


# BerkeleyDB v4.8
WORKDIR /
RUN wget "http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz"
RUN tar -xvzf db-4.8.30.NC.tar.gz
WORKDIR db-4.8.30.NC/build_unix
RUN ../dist/configure --disable-shared --enable-cxx --disable-replication --with-static --with-pic --prefix=/usr/local && make && make install


# Boost v1.65.0
WORKDIR /
RUN wget "https://sourceforge.net/projects/boost/files/boost/1.65.0/boost_1_65_0.tar.bz2"
RUN tar -xvf boost_1_65_0.tar.bz2
WORKDIR boost_1_65_0
RUN ./bootstrap.sh --with-libraries=all --prefix=/usr/local
RUN ./b2 install --with=all


# openssl v1.0.2g
# WORKDIR /
# RUN wget "http://www.openssl.org/source/openssl-1.0.2g.tar.gz"
# RUN tar -xvxf openssl-1.0.2g.tar.gz
# WORKDIR openssl-1.0.2g
# RUN ./config --prefix=/usr/local enable-ec enable-ecdh enable-ecdsa
# RUN make
# RUN make install
# RUN echo "/usr/local/openssl/lib" >> /etc/ld.so.conf
# RUN ldconfig
# RUN openssl version
RUN apt-get install libssl-dev -y


WORKDIR /salus
COPY . .

RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

