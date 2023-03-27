From ubuntu:latest

RUN apt update && apt install mpich -y && apt install make -y

ARG WORKDIR=/app
ENV WORKDIR ${WORKDIR}
RUN mkdir ${WORKDIR}
WORKDIR ${WORKDIR}

ENV MPICH_PORT_RANGE "20000:20100"

CMD ["/bin/bash"]