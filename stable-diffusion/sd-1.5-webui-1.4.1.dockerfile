FROM openrhino/stable-diffusion:base-webui-1.4.1
USER SD
ADD --chown=SD:SD https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors /home/SD/stable-diffusion-webui/models/Stable-diffusion/
WORKDIR /home/SD/stable-diffusion-webui