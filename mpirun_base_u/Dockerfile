FROM zhuhe0321/mpich-ubuntu:v1.0 as builder

FROM ubuntu:latest
COPY --from=builder /usr/bin/mpiexec.hydra /usr/bin/mpirun
COPY --from=builder /usr/bin/hydra_pmi_proxy /usr/bin/hydra_pmi_proxy
COPY libs/ /lib/x86_64-linux-gnu/

WORKDIR /app
ENV MPICH_PORT_RANGE "20000:20100"

CMD ["/bin/bash"]