#! /usr/bin/env bash
if [ -d "${DESTDIR}/${2}/${3}" ]; then
    rm -rf "${DESTDIR}/${2}/${3}"
fi

ln -rsf "${DESTDIR}/${1}/${3}" "${DESTDIR}/${2}"