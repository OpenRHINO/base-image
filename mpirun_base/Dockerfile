FROM zhuhe0321/mpich:v2.0 as builder

FROM alpine:3.15
COPY --from=builder /usr/local/bin/mpiexec.hydra /usr/local/bin/mpirun
COPY --from=builder /usr/local/bin/hydra_pmi_proxy /usr/local/bin/hydra_pmi_proxy
COPY libmpi.so.12  /usr/lib/libmpi.so.12

WORKDIR /app
ENV MPICH_PORT_RANGE "20000:20100"

CMD ["/bin/ash"]