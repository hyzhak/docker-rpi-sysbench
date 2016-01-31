FROM resin/rpi-raspbian:wheezy
MAINTAINER Eugene Krevenets <ievgenii.krevenets@gmail.com>

RUN apt-get update && apt-get install -y sysbench

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["--test-cpu", "--test-file-io"]
