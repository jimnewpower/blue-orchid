#!/bin/bash
mkdir -p bin/

cd src/main
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ../../bin/main main.go
chmod u+x ../../bin/main

cd ../../
echo "Contents of bin/"
ls -l bin/

