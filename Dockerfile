FROM rpi-mysql:latest
MAINTAINER Eugene Krevenets <ievgenii.krevenets@gmail.com>

RUN apt-get update && apt-get install sysbench

CMD ["sysbench", "--test=cpu", "--cpu-max-prime=20000", "run"]
