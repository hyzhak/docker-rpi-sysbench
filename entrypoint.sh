#!/bin/bash

#
# Based on https://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench
#

set -e

function join { local IFS="$1"; shift; echo "$*"; }

if [[ $# -eq 0 ]]; then
  testCPU=true
  testFileIO=true
  testMySQL=true
else
  testCPU=false
  testFileIO=false
  testMySQL=false
  splitCommand=false
  beforeSplit=()
  badOptions=()
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
          --)
            splitCommand=true

            badOptions=()
            testCPU=false
            testFileIO=false
            testMySQL=false
            ;;
          *)
            badOptions+=($1)
            ;;
      esac

      if [ "$splitCommand" = false ]; then
        beforeSplit+=($1)
      fi

      shift
  done

  if [ "$splitCommand" = true ]; then
    eval $(join " " "${beforeSplit[@]}")
  fi

  if [ ${#badOptions[@]} -gt 0 ]; then
    echo "bad options: $(join , "${badOptions[@]}")"
  fi
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

  sysbench --test=fileio --file-total-size="$FILE_SIZE" prepare

  sysbench --test=fileio --file-total-size="$FILE_SIZE" \
           --file-test-mode=rndrw --init-rng=on --max-time=300 \
           --max-requests=0 run

  sysbench --test=fileio --file-total-size="$FILE_SIZE" cleanup
fi

if [ "$testMySQL" = true ]; then
  echo
  echo "∙∙∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo
  echo "Start MySql Test"
  echo
  echo "∙∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)===>"
  echo

  sysbench --test=oltp \
           --oltp-table-size="$TABLE_SIZE" \
           --mysql-host="$DB_HOST" \
           --mysql-db="$TEST_DB" \
           --mysql-user=root \
           --mysql-password="$MYSQL_ROOT_PASSWORD" \
           prepare

  sysbench --test=oltp \
           --oltp-table-size="$TABLE_SIZE" \
           --mysql-host="$DB_HOST" \
           --mysql-db="$TEST_DB" \
           --mysql-user=root \
           --mysql-password="$MYSQL_ROOT_PASSWORD" \
           --max-time=60 \
           --oltp-read-only=on \
           --max-requests=0 \
           --num-threads=8 \
           run

  sysbench --test=oltp \
           --mysql-host="$DB_HOST" \
           --mysql-db="$TEST_DB" \
           --mysql-user=root \
           --mysql-password="$MYSQL_ROOT_PASSWORD" \
           cleanup
fi

exit 0
