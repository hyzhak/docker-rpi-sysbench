#!/bin/bash

#
# Based on https://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench
#

set -e

if [[ $# -eq 0 ]]; then
  testCPU=true
  testFileIO=true
else
  testCPU=false
  testFileIO=false
  while test $# -gt 0
  do
      case "$1" in
          --test-cpu)
            testCPU=true
            ;;
          --test-file-io)
            testFileIO=true
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

  fileSize = 8G

  sysbench --test=fileio --file-total-size="$fileSize" prepare
  sysbench --test=fileio --file-total-size="$fileSize" --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
  sysbench --test=fileio --file-total-size="$fileSize" cleanup
fi

exit 0
