FROM hypriot/rpi-mysql:latest
MAINTAINER Eugene Krevenets <ievgenii.krevenets@gmail.com>

RUN apt-get update && apt-get install -y sysbench

CMD ["sysbench", "--test=cpu", "--cpu-max-prime=20000", "run"]
