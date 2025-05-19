FROM ubuntu:20.04

WORKDIR /home

# Base setup
RUN apt update && apt upgrade -y && apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3 python3-pip \
    libboost-python-dev libboost-numpy-dev \
    libcpprest-dev wget curl git

# Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install numpy pyelftools pefile \
    "ray[serve]>=2.9.0" transformers torch

# ONNX Runtime
RUN wget -q https://github.com/microsoft/onnxruntime/releases/download/v1.10.0/onnxruntime-linux-x64-1.10.0.tgz && \
    tar -zxf onnxruntime-linux-x64-1.10.0.tgz --strip-components=2 -C /usr/local/lib --wildcards "*/lib/lib*" && \
    rm onnxruntime-linux-x64-1.10.0.tgz

COPY . .
ENV PYTHONPATH="${PYTHONPATH}:/home"
# Expose Ray + Serve ports
EXPOSE 6379 8265 8000

CMD ["bash"]
