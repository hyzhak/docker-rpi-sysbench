#!/bin/bash

#
# Based on https://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench
#

set -e

if [[ $# -eq 0 ]]; then
  testCPU=true
  testFileIO=true
  testMySQL=true
else
  testCPU=false
  testFileIO=false
  testMySQL=false
  while test $# -gt 0
  do
      case "$1" in
          --test-cpu)
            testCPU=true
            ;;
          --test-file-io)
            testFileIO=true
            ;;
          --test-mysql)
            testMySQL=true
            ;;
          *)
            echo "bad option $1"
            ;;
      esac
      shift
  done
fi

if [ "$testCPU" = true ]; then
  echo
  echo "∙∙∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo
  echo "Start Cpu Test"
  echo
  echo "∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo

  sysbench --test=cpu --cpu-max-prime=20000 run
fi

if [ "$testFileIO" = true ]; then
  echo
  echo "∙∙∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo
  echo "Start FileIo Test"
  echo
  echo "∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo

  fileSize="8G"

  sysbench --test=fileio --file-total-size="$fileSize" prepare

  sysbench --test=fileio --file-total-size="$fileSize" --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run

  sysbench --test=fileio --file-total-size="$fileSize" cleanup
fi

if [ "$testMySQL" = true ]; then
  echo
  echo "∙∙∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo
  echo "Start MySql Test"
  echo
  echo "∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo

  tableSize=1000000

  sysbench --test=oltp --oltp-table-size="$tableSize" --mysql-db=test --mysql-user=root \
           --mysql-password="$MYSQL_ENV_MYSQL_ROOT_PASSWORD" prepare

  sysbench --test=oltp --oltp-table-size="$tableSize" --mysql-db=test --mysql-user=root \
           --mysql-password="$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --max-time=60 \
           --oltp-read-only=on --max-requests=0 --num-threads=8 run

  sysbench --test=oltp --mysql-db=test --mysql-user=root \
           --mysql-password=yourrootsqlpassword cleanup
fi

exit 0
