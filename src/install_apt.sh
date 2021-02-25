#!/bin/bash

DEST_BIN='/usr/local/bin'
DEST_APT='/etc/apt/apt.conf.d'

SCR_BUILD='build_pcf2127mod'
SCR_APT='c0_build_pcf2127mod'


if [ ! -z "$1" ]; then
  if [ "$1" = 'install' ]; then
    echo 'install scripts'
    install ${SCR_BUILD} ${DEST_BIN}
    cp ${SCR_APT} ${DEST_APT}
  elif [ "$1" = 'uninstall' ]; then
    echo 'uninstall scripts'
    rm ${DEST_BIN}/${SCR_BUILD}
    rm ${DEST_APT}/${SCR_APT}
  fi
fi
exit 0

