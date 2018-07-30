#!/bin/bash
./full_run.sh 1
../scp.sh
../restart.sh
./full_run.sh 0.8
