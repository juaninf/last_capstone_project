#!/bin/bash

NUM_PROCESSES=100

for i in $(seq 1 $NUM_PROCESSES); do
    python3 client_request.py &
done

wait
