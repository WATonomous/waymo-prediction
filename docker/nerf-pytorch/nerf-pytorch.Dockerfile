FROM nvidia/cuda:11.7.1-devel-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

# ================= Dependencies ===================
# python
RUN apt-get update -y
ENV http_proxy $HTTPS_PROXY
ENV https_proxy $HTTPS_PROXY

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 wget unzip -y

RUN apt-get install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# kilonerf dependencies
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3 -m pip install pip --upgrade

RUN pip install \ 
    numpy \
    imageio \
    imageio-ffmpeg \
    matplotlib \
    configargparse \
    tensorboard>=2.0 \
    tqdm \
    opencv-python \
    
    # Weights and Biases login for mlOPs
    moviepy \
    wandb

RUN pip install torch torchvision torchaudio

# ================= User & Environment Setup, Repos ===================
ENV DEBIAN_FRONTEND interactive
ENV PATH="/usr/local/cuda-11.7/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/cuda-11.7/lib64:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH"

COPY docker/fixuid_setup.sh /project/fixuid_setup.sh
RUN /project/fixuid_setup.sh
USER docker:docker
WORKDIR /home/docker/

# Weights and Biases login for mlOPs
ARG USER_WANDB_MODE
ARG USER_WANDB_KEY
ENV WANDB_MODE $USER_WANDB_MODE

RUN if [ ! -z $USER_WANDB_KEY ]; then wandb login $USER_WANDB_KEY; fi

WORKDIR /home/docker/nerf-pytorch
ENTRYPOINT ["/usr/local/bin/fixuid"]
