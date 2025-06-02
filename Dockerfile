FROM ubuntu:20.04

WORKDIR /home

RUN sed -i 's|http://archive.ubuntu.com|http://azure.archive.ubuntu.com|g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    rsync \
    libpopt0 \
    python3 python3-pip \
    libboost-python-dev libboost-numpy-dev \
    libcpprest-dev wget curl git && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*


# Python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install numpy
RUN pip3 install pyelftools
RUN pip3 install pefile
RUN pip3 install "ray[serve]>=2.9.0"
RUN pip3 install transformers
RUN pip3 install torch

# ONNX Runtime
RUN wget -q https://github.com/microsoft/onnxruntime/releases/download/v1.10.0/onnxruntime-linux-x64-1.10.0.tgz && \
    tar -zxf onnxruntime-linux-x64-1.10.0.tgz --strip-components=2 -C /usr/local/lib --wildcards "*/lib/lib*" && \
    rm onnxruntime-linux-x64-1.10.0.tgz

COPY . .
ENV PYTHONPATH="${PYTHONPATH}:/home"
# Expose Ray + Serve ports
EXPOSE 6379 8265 8000

CMD ["bash"]
