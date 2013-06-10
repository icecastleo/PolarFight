#!/bin/sh

#  TP-update.sh
#  CastleFight
#
#  Created by 朱 世光 on 13/6/8.
#

TP=/usr/local/bin/TexturePacker
if [ "${ACTION}" = "clean" ]
then
# remove sheets - please add a matching expression here
rm -f ../SpriteSheets/*.pvr.ccz
rm -f ../SpriteSheets/*.pvr
rm -f ../SpriteSheets/*.plist
rm -f ../SpriteSheets/*.png
else

#ensure the file exists
if [ -f "${TP}" ]; then
echo "building..."
# create directory
mkdir -p ../SpriteSheets
# create assets
${TP} *.tps
exit 0
else
#if here the TexturePacker command line file could not be found
echo "TexturePacker tool not installed in ${TP}"
echo "skipping requested operation."
exit 0
fi
fi
exit 0