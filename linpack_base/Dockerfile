FROM alpine:3.11.3

COPY package/* /tmp/
COPY config/* /tmp/

RUN apk update && apk add --no-cache gcc gfortran g++ make libc6-compat

RUN tar -xzf /tmp/blas-3.8.0.tgz -C /tmp/ \
    && cd /tmp/BLAS-3.8.0/ \
    && make -j \
    && ar rv libblas.a *.o

RUN tar -xzf /tmp/cblas.tgz -C /tmp/ \
    && cd /tmp/CBLAS/ \
    && cp /tmp/BLAS-3.8.0/blas_LINUX.a ./ \
    && mv /tmp/Makefile.in /tmp/CBLAS/Makefile.in \
    && make -j alllib \ 
    && cp /tmp/CBLAS/lib/* /usr/local/lib/ \
    && cp /tmp/BLAS-3.8.0/blas_LINUX.a /usr/local/lib/

RUN tar -xzf /tmp/mpich-3.2.1.tar.gz -C /tmp/ \
    && cd /tmp/mpich-3.2.1/ \
    && ./configure --prefix=/usr/local \
    && make -j \
    && make install \
    && export PATH=/usr/local/bin:$PATH

RUN tar -xzf /tmp/hpl-2.3.tar.gz -C /root/ \
    && cd /root/hpl-2.3/ \
    && mv /tmp/Make.Linux_PII_CBLAS ./ \
    && mv /tmp/Make.top ./ \
    && mv /tmp/Makefile ./ \
    && make -j arch=Linux_PII_CBLAS

RUN rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apk/* \
    && rm -rf /etc/apk/cache/* \
    && rm -rf /tmp/* \
    && rm -rf /tmp/._BLAS-3.8.0 \
    && apk del --purge g++ make libc6-compat gcc

RUN mkdir /app && cd /root/hpl-2.3/bin/Linux_PII_CBLAS/ \
    && cp ./* /app/ \
    && rm -rf /root/hpl-2.3/

COPY HPL.dat /app/

WORKDIR /app
ENV MPICH_PORT_RANGE "20000:20100"
 
CMD ["/bin/ash"]
