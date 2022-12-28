#! /usr/bin/env bash
mkdir -p "${DESTDIR}/${2}"

if [[ ! -z "${4}" ]]; then
  ln -rsvf "${DESTDIR}/${1}/${3}" "${DESTDIR}/${2}/${4}"
else
  ln -rsvf "${DESTDIR}/${1}/${3}" "${DESTDIR}/${2}"
fi

if [[ ! -z "${5}" ]]; then
  ln -rsvf "${DESTDIR}/${1}/${3}" "${DESTDIR}/${2}/${5}"
fi