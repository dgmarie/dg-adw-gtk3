#! /bin/bash

INKSCAPE="flatpak run org.inkscape.Inkscape"
OPTIPNG="/usr/bin/optipng"

SRC_FILE="assets.svg"
ASSETS_DIR="assets"
INDEX="assets.txt"
WINDOWS_SRC_FILE="windows-nord-assets.svg"

for i in `cat $INDEX`
do 
if [ -f $ASSETS_DIR/$i.png ]; then
    echo $ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-filename=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null #\
    # && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png 
fi
if [ -f $ASSETS_DIR/$i@2.png ]; then
    echo $ASSETS_DIR/$i@2.png exists.
else
    echo
    echo Rendering $ASSETS_DIR/$i@2.png
    $INKSCAPE --export-id=$i \
              --export-dpi=180 \
              --export-id-only \
              --export-filename=$ASSETS_DIR/$i@2.png $SRC_FILE >/dev/null #\
    # && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i@2.png 
fi
done
exit 0
