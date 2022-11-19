#! /usr/bin/env bash
mkdir -p "${DESTDIR}/${3}"
cp -f "${1}" "${DESTDIR}/${2}"
if [[ ! -z "${4}" ]] ; then
  cp -f "${1}" "${DESTDIR}/${4}"
fi
