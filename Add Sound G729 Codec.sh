#!/bin/bash

# add Sound Codec G729
echo -e "\n\033[5;4;47;34m  add Sound Codec G729 \033[0m\n"

g729url=http://asterisk.hosting.lv/bin/codec_g729-ast170-gcc4-glibc-x86_64-core2-sse4.so
g723url=http://asterisk.hosting.lv/bin/codec_g723-ast170-gcc4-glibc-x86_64-core2-sse4.so

if [ -d /usr/lib/asterisk/modules ]; then
cd /usr/lib/asterisk/modules/
g729=$(ls /usr/lib/asterisk/modules/ |grep codec_g729.so |wc -l)
g723=$(ls /usr/lib/asterisk/modules/ |grep codec_g723.so |wc -l)
if [ $g729 == 0 -o $g723 == 0 ];
then
wget -c -O codec_g729.so $g729url
wget -c -O codec_g723.so $g723url
chmod 755 codec_g729.so
chown asterisk:asterisk codec_g729.so
chmod 755 codec_g723.so
chown asterisk:asterisk codec_g723.so
asterisk -rx "module reload codec_g729.so"
asterisk -rx "module reload codec_g723.so"

echo -e "\n\033[5;4;47;34m  codec_g723 and codec_g729 is installed \033[0m\n"
else
echo -e "\n\033[5;4;47;34m  codec_g723 and codec_g729 already exists  \033[0m\n"
fi
fi
# Load code g729 with asterisk 
checkg729=$(grep -w "codec_g729.so" /etc/asterisk/modules.conf |wc -l)
checkg723=$(grep -w "codec_g723.so" /etc/asterisk/modules.conf |wc -l)
if [ $checkg729 == 0 -o $checkg723 == 0 ]; then
sed -i '$i\load = codec_g729.so' /etc/asterisk/modules.conf
sed -i '$i\load = codec_g723.so' /etc/asterisk/modules.conf
echo -e "\n\033[5;4;47;34m  Load codec_g729 with asterisk  \033[0m\n"
else 
echo -e "\n\033[5;4;47;34m  codec_g729 already configured  \033[0m\n"
fi

# Restart services
fwconsole restart

asterisk -rx "core show translation"