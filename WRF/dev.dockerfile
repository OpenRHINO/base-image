FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/codeserver:v1.5.0
# switch to root user to install packages
USER root 
RUN apt update && apt install -y \
    zsh git\
    build-essential csh gfortran m4 libcurl4-gnutls-dev zlib1g-dev\
    mpich libmpich-dev

COPY docker-linux-x86_64-20.10.9 /usr/local/bin/docker
ADD https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh .
RUN chmod +x install.sh && ./install.sh

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

WORKDIR /home/jovyan
RUN git clone --recurse-submodules https://github.com/wrf-model/WRF 
WORKDIR /home/jovyan/WRF
RUN git checkout release-v4.4.2
ENV NETCDF=$DIR/NETCDF
RUN echo "34" | ./configure && ./compile -j 4 em_real

WORKDIR /WRFdependencies
ADD https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz .
RUN tar xzvf jasper-1.900.1.tar.gz && rm jasper-1.900.1.tar.gz
WORKDIR /WRFdependencies/jasper-1.900.1
RUN ./configure --prefix=$DIR/JASPER && make -j 4 install

WORKDIR /home/jovyan
RUN git clone https://github.com/wrf-model/WPS
WORKDIR /home/jovyan/WPS
RUN git checkout v4.4
ENV JASPERLIB=$DIR/JASPER/lib JASPERINC=$DIR/JASPER/include
RUN echo "3" | ./configure 
# workaround for "gfortran: error: CONFIGURE_COMPAT_FLAGS: No such file or directory"
RUN sed -i '/CONFIGURE_COMPAT_FLAGS/d' configure.wps
RUN ./compile

WORKDIR /home/jovyan