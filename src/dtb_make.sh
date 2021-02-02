#!/bin/bash

SRC='i2c-rtc-overlay-patched.dts'
TARGET='i2c-rtc-pcf2127.dtbo'
DST_0='/boot/firmware/overlays'
DST_1='/boot/overlays'

if [ $1 -a $1 = 'clean' -a -f ${TARGET} ]; then
  rm ${TARGET}
  exit 0
fi

if [ -f ${SRC} ]; then
  echo "make dtbo from ${SRC} ..."
  dtc -q -@ -I dts -O dtb -o ${TARGET} ${SRC}
fi

if [ $1 -a $1 = 'install' ]; then
  if [ -f ${TARGET} ]; then
    if [ -d ${DST_0} ]; then
      echo "copy ${TARGET} to ${DST_0} ..."
      cp ${TARGET} ${DST_0}
    elif [ -d ${DST_1} ]; then
      echo "copy ${TARGET} to ${DST_1} ..."
      cp ${TARGET} ${DST_1}
    fi
  fi
fi
