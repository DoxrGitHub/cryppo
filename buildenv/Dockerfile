FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install g++ \
libc6 ninja-build cmake libssl-dev elfutils libelf-dev gcc-4.8 g++-4.8 -y 

RUN mkdir -p /app

WORKDIR /app
COPY . .