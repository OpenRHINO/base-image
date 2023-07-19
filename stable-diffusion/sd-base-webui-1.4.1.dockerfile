FROM    nvidia/cuda:12.2.0-base-ubuntu20.04
RUN     apt-get update
ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ=Asia/Shanghai
RUN     apt-get install -y wget git python3 python3-venv libgl1-mesa-glx libglib2.0-0
RUN     useradd -ms /bin/bash SD
WORKDIR /home/SD
USER    SD
RUN     git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /home/SD/stable-diffusion-webui
RUN     git checkout v1.4.1 && cp launch.py install.py && sed -i '/start()/d' install.py
ENV     LAUNCH_SCRIPT=install.py
RUN     chmod +x /home/SD/stable-diffusion-webui/webui.sh && \
    /home/SD/stable-diffusion-webui/webui.sh --skip-torch-cuda-test
ENV     LAUNCH_SCRIPT=
EXPOSE  7860    
CMD     ["/home/SD/stable-diffusion-webui/webui.sh", "--enable-insecure-extension-access", "--listen", "--api"]