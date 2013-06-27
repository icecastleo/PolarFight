#!/bin/sh

#  TP-update.sh
#  CastleFight
#
#  Created by 朱 世光 on 13/6/8.
#

TP=/usr/local/bin/TexturePacker
cd "${PROJECT_DIR}/${PROJECT}"

if [ "${ACTION}" = "clean" ] && [ -f "${TP}" ]
then
# remove sheets - please add a matching expression here
rm -f Resources/SpriteSheets/*.pvr.ccz
rm -f Resources/SpriteSheets/*.pvr
rm -f Resources/SpriteSheets/*.plist
rm -f Resources/SpriteSheets/*.png
else

#ensure the file exists
if [ -f "${TP}" ]; then
echo "building..."
# create directory
mkdir -p Resources/SpriteSheets
# create assets
${TP} Resources/Assets/*.tps
exit 0
else
#if here the TexturePacker command line file could not be found
echo "TexturePacker tool not installed in ${TP}"
echo "skipping requested operation."
exit 0
fi
fi
exit 0