#!/bin/bash

SRC_DIR='/usr/src/pcf2127mod-1.0.0'

if [ ! -z "$1" ]; then
  if [ "$1" == 'install' ]; then

    echo 'install'

    # make sorce directory
    if [ -z "${SRC_DIR}" ]; then
      exit 1
    fi

    if [ ! -d "${SRC_DIR}" ]; then
      mkdir "${SRC_DIR}"
    fi
    if [ ! -d "${SRC_DIR}/src" ]; then
      mkdir "${SRC_DIR}/src"
    fi

    # copy files
    cp ../src/rtc-pcf2127.c ../src/Makefile "${SRC_DIR}/src"
    cp dkms.conf "${SRC_DIR}"

    # dkms add
    dkms add -m pcf2127mod -v 1.0.0

  elif [ "$1" == 'uninstall' ]; then

    # dkms remove
    dkms remove -m pcf2127mod -v 1.0.0 --all

    # make sorce directory
    if [ -z "${SRC_DIR}" ]; then
      exit 1
    fi

    # remove files
    rm "${SRC_DIR}/src/rtc-pcf2127.c" "${SRC_DIR}/src/Makefile" "${SRC_DIR}/dkms.conf"

    if [ -d "${SRC_DIR}/src" ]; then
      rmdir "${SRC_DIR}/src"
    fi
    if [ -d "${SRC_DIR}" ]; then
      rmdir "${SRC_DIR}"
    fi

  fi
fi

exit 0
