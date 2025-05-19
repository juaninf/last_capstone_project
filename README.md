# Description

This repo contains scripts used to start a ray cluster with a head and a worker. This cluster serve disassembly of binary machine code using DeepDi. To start the cluster we can use

> docker-compose down -v && docker-compose up --build

To perform a client request

> cd client && python3 client_request.py