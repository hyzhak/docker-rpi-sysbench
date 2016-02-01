FROM resin/rpi-raspbian:wheezy
MAINTAINER Eugene Krevenets <ievgenii.krevenets@gmail.com>

RUN apt-get update && \
    apt-get install -y sysbench && \
    apt-get install -y wget

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-armhf-v0.2.0.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-armhf-v0.2.0.tar.gz

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["--test-cpu", "--test-file-io"]
