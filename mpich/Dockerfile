FROM alpine:3.15

ARG REQUIRE="sudo build-base"
RUN   sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
      apk update && apk upgrade \
      && apk add --no-cache ${REQUIRE}
RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl

ARG MPICH_VERSION="3.2"
ARG MPICH_CONFIGURE_OPTIONS="--disable-fortran"
ARG MPICH_MAKE_OPTIONS

RUN mkdir /tmp/mpich-src
WORKDIR /tmp/mpich-src
RUN wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
      && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
      && cd mpich-${MPICH_VERSION}  \
      && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
      && make ${MPICH_MAKE_OPTIONS} -j 4 && make install \
      && rm -rf /tmp/mpich-src

WORKDIR /
RUN rm -rf /tmp/*

ARG WORKDIR=/app
ENV WORKDIR ${WORKDIR}
RUN mkdir ${WORKDIR}

WORKDIR ${WORKDIR}

ENV MPICH_PORT_RANGE "20000:20100"
 
CMD ["/bin/ash"]
