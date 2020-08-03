FROM php:7.2-apache

RUN apt update
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


WORKDIR /app
COPY . ./
RUN sed $'s/\r$//' ./run.sh > ./run.Unix.sh


#CMD sh run.sh
CMD ["/usr/bin/supervisord"]

EXPOSE 81