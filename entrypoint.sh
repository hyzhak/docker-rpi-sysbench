#!/bin/bash
set -e

if [[ $# -eq 0 ]]; then
  testCPU=true
else
  testCPU=false
  while test $# -gt 0
  do
      case "$1" in
          --test-cpu)
            testCPU=true
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

  sysbench --test=cpu --cpu-max-prime=20000 run
fi

exit 0
