#!/bin/bash

## REQUIRES: librsvg, imagemagick
#### On OS X:   `brew install librsvg imagemagick`
#### On Debian: `apt-get install librsvg2-bin imagemagick`
#### On Arch:   `pacman -S librsvg imagemagick`

if [ -z $1 ]; then
	echo "You must specify an svg file to generate favicon images from!"
	exit 1
fi


SVG_PATH=$1
FAVICON_NAME="./favicon"
PRE_FAVICON_NAME="/tmp/pre-favicon"
PRE_FAVICON_GLOB="${PRE_FAVICON_NAME}-*"
ICO_PATH="${FAVICON_NAME}.ico"

FAVICON_ICO_SIZES=(
	16 24 32 48
)
FAVICON_PNG_SIZES=(
	32 60 72 76 120 144 152 180
)


function svg2png {
	OUTPUT_NAME=$1
	SIZE=$2
	SILENT=$3

	OUTPUT_PNG="${OUTPUT_NAME}-${SIZE}.png"

	rsvg-convert $SVG_PATH -w $SIZE -o $OUTPUT_PNG 1>/dev/null
	if ! $SILENT; then
		echo "Created PNG: ${OUTPUT_PNG}"
	fi
}

for SIZE in ${FAVICON_PNG_SIZES[@]}; do
	svg2png $FAVICON_NAME $SIZE false
done

for SIZE in ${FAVICON_ICO_SIZES[@]}; do
	svg2png $PRE_FAVICON_NAME $SIZE true
done

convert $PRE_FAVICON_GLOB $ICO_PATH
echo "Created ICO: $ICO_PATH..."
rm $PRE_FAVICON_GLOB
