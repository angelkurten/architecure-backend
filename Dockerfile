FROM golang:1.8
ENV VER 1.1.1

COPY . ./

RUN chmod +x run.sh


ENV BIND_ADDR 0.0.0.0:3123
EXPOSE 3123