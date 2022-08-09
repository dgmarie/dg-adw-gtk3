#! /usr/bin/env bash
mkdir -p $3
cp -f $1 $2
if [[ ! -z "$4" ]] ; then
  cp -f $1 $4
fi
