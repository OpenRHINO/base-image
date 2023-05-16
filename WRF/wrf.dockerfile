FROM ubuntu:20.04 as builder
# switch to root user to install packages
USER root 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    zsh git\
    build-essential csh gfortran m4 libcurl4-gnutls-dev zlib1g-dev\
    mpich libmpich-dev

# prepare some dependencies that cannot be installed by apt
WORKDIR /WRFdependencies
ADD https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz .
RUN tar xzvf netcdf-c-4.9.2.tar.gz && rm netcdf-c-4.9.2.tar.gz
WORKDIR /WRFdependencies/netcdf-c-4.9.2
ENV DIR="/WRFdependencies"
RUN ./configure --prefix=$DIR/NETCDF --disable-dap --disable-hdf5 --disable-libxml2 --enable-netcdf4 --enable-shared && make -j 4 && make -j 4 install

WORKDIR /WRFdependencies
ADD https://downloads.unidata.ucar.edu/netcdf-fortran/4.5.4/netcdf-fortran-4.5.4.tar.gz .
RUN tar xzvf netcdf-fortran-4.5.4.tar.gz && rm netcdf-fortran-4.5.4.tar.gz
WORKDIR /WRFdependencies/netcdf-fortran-4.5.4
ENV LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH CPPFLAGS="-I$DIR/NETCDF/include" LDFLAGS="-L$DIR/NETCDF/lib"
RUN ./configure --prefix=$DIR/NETCDF --enable-shared && make -j 4 && make -j 4 install

# copy the source code and compile
# users may modify and config the source code in the dev environment
COPY . /WRF/ 
WORKDIR /WRF
ENV NETCDF=$DIR/NETCDF
RUN echo "34" | ./configure && ./compile -j 4 em_real

# use the ldd analysis script to pick the necessary dependencies
WORKDIR /
COPY ldd.sh .
RUN bash ldd.sh wrf.exe

# 2-stage build
FROM ubuntu:20.04

COPY --from=builder /3rdParty/mpiexec/mpiexec.hydra /usr/bin/mpirun
COPY --from=builder /3rdParty/mpiexec/hydra_pmi_proxy /usr/local/bin/hydra_pmi_proxy

WORKDIR /app
COPY --from=builder /WRF/main/wrf.exe /app/mpi-func
COPY --from=builder /3rdParty/libs/ /lib/

RUN apt update 
RUN apt install ash

ENV MPICH_PORT_RANGE "20000:20100"

ENTRYPOINT ["mpirun"]
CMD ["-n", "4", "/app/mpi-func"]