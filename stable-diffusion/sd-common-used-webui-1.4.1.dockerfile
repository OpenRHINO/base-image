FROM openrhino/stable-diffusion:base-webui-1.4.1
USER SD
ADD --chown=SD:SD https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors /home/SD/stable-diffusion-webui/models/Stable-diffusion/
ADD --chown=SD:SD https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.safetensors /home/SD/stable-diffusion-webui/models/Stable-diffusion/
WORKDIR /home/SD/stable-diffusion-webui/extensions/
RUN git clone https://github.com/lifeisboringsoprogramming/sd-webui-xldemo-txt2img.git && \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git
WORKDIR /home/SD/stable-diffusion-webui