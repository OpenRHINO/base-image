FROM openrhino/stable-diffusion:base-webui-latest
USER SD
ADD --chown=SD:SD https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors /home/SD/stable-diffusion-webui/models/Stable-diffusion/
WORKDIR /home/SD/stable-diffusion-webui