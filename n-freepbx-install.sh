#!/bin/bash

freepbx() {
# Disable selinux
echo -e "\n\033[5;4;47;34m Disable selinux \033[0m\n"
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0

# Update Your System
echo -e "\n\033[5;4;47;34m Update Your System \033[0m\n"

yum -y groupinstall core base "Development Tools"
while [[ $(yum grouplist installed |grep "Development Tools"|wc -l) == "0" ]];do
yum -y groupinstall core base "Development Tools"
done
yum -y install ngrep
yum -y install sngrep

# Add the Asterisk User
echo -e "\n\033[5;4;47;34m  Add the Asterisk User \033[0m\n"

adduser asterisk -m -c "Asterisk User"

# Install Additional Required Dependencies
echo -e "\n\033[5;4;47;34m  Install Additional Required Dependencies \033[0m\n"

depend_pkg="lynx tftp-server unixODBC mysql-connector-odbc mariadb-server mariadb
  httpd ncurses-devel sendmail sendmail-cf sox newt-devel libxml2-devel libtiff-devel
  audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie
  cronie-anacron wget vim uuid-devel sqlite-devel net-tools gnutls gnutls-devel python-devel texinfo
  libuuid-devel libedit libedit-devel"

max_tries=2
try=$max_tries
result="error"
while (( try > 0 )) && [[ "$result" == 'error' ]]; do
yum -y install $depend_pkg && result='ok' || result='error'
if [[ "$result" == 'error' ]]; then
yum list installed $depend_pkg
fi
try=$((try-1))
done


# Install php
echo -e "\n\033[5;4;47;34m Install php \033[0m\n"

yum remove -y php*
php_pkg="php72w php72w-cli php72w-common php72w-pdo php72w-mysql php72w-mbstring
 php72w-pear php72w-process php72w-xml php72w-opcache php72w-ldap php72w-intl php72w-soap"

max_tries=2
try=$max_tries
result="error"
while (( try > 0 )) && [[ "$result" == 'error' ]]; do
yum install -y $php_pkg && result='ok' || result='error'
if [[ "$result" == 'error' ]]; then
yum list installed $php_pkg
fi
try=$((try-1))
done


# Install nodejs
echo -e "\n\033[5;4;47;34m Install nodejs \033[0m\n"

yum install -y nodejs
while [[ $(yum list installed nodejs |grep nodejs|wc -l) == "0" ]];do
yum install -y nodejs
done


# Enable and Start MariaDB
systemctl enable mariadb.service
systemctl start mariadb

# initial database
#; mysql_secure_installation --use-default
echo -e "\n\033[5;4;47;34m initial database \033[0m\n"

mysql -u root <<EOF
UPDATE mysql.user SET authentication_string=PASSWORD('') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Enable and Start Apache
systemctl enable httpd.service
systemctl start httpd.service


# Install Legacy Pear requirements
#pear install Console_Getopt

# downloading packages
echo -e "\n\033[5;4;47;34m downloading packages \033[0m\n"

#pkgs="iksemel-master.zip jansson.tar.gz asterisk-17-current.tar.gz freepbx-15.0-latest.tgz"
#wget -c https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
#wget -c https://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz

if  [ ! -e "iksemel-master.zip" ]; then
wget -c https://github.com/meduketto/iksemel/archive/master.zip -O iksemel-master.zip
fi
if [ ! -e "jansson.tar.gz" ]; then
wget -c https://github.com/akheron/jansson/archive/v2.12.tar.gz -O jansson.tar.gz
fi
if [ ! -e "asterisk-17-current.tar.gz" ]; then
wget -c https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-17-current.tar.gz
fi
if [ ! -e "freepbx-15.0-latest.tgz" ]; then
wget -c http://mirror.freepbx.org/modules/packages/freepbx/freepbx-15.0-latest.tgz
fi

# extracting
#tar -zxvf dahdi-linux-complete-current.tar.gz
#tar -zxvf libpri-current.tar.gz

unzip iksemel-master.zip
tar -zxvf jansson.tar.gz
tar -zxvf asterisk-17-current.tar.gz
tar -zxvf freepbx-15.0-latest.tgz


# Install iksemel
echo -e "\n\033[5;4;47;34m Install iksemel \033[0m\n"

rm -f iksemel-master.zip
cd iksemel-master
./autogen.sh
./configure
make
make install
cd ..


# install dahdi
#echo -e "\n\033[5;4;47;34m install dahdi \033[0m\n"

#rm -rf dahdi-linux-complete-current.tar.gz
#cd dahdi-linux-complete-*
#make all
#make install
#make config
#cd ..

# Building and Installing LibPRI
#echo -e "\n\033[5;4;47;34m Building and Installing LibPRI \033[0m\n"

#rm -rf libpri-current.tar.gz
#cd libpri-*
#make
#make install
#cd ..

# Compile and Install jansson
echo -e "\n\033[5;4;47;34m Compile and Install jansson \033[0m\n"

rm -f jansson.tar.gz
cd jansson-*
autoreconf -i
./configure --libdir=/usr/lib64
make
make install
cd ..

# Configuring Asterisk
echo -e "\n\033[5;4;47;34m Configuring Asterisk \033[0m\n"

rm -f asterisk-*-current.tar.gz
cd asterisk-*
contrib/scripts/get_mp3_source.sh
contrib/scripts/install_prereq install
./configure --with-pjproject-bundled --with-jansson-bundled  --with-iksemel --libdir=/usr/lib64 --with-crypto --with-ssl=ssl --with-srtp
make menuselect.makeopts
menuselect/menuselect --enable app_macro --enable format_mp3 menuselect.makeopts
## turn on 'format_mp3' and res_snmp module from Resource Modules. 
## You will be prompted at the point to pick which modules to build. 
## Most of them will already be enabled, but if you want to have MP3 support (eg, for Music on Hold),
## you need to manually turn on 'format_mp3' on the first page.
## After selecting 'Save & Exit' you can then continue
# Building and Installing Asterisk
make
make install
make config
## Installing Sample Files
#make samples
## generate logfiles
make install-logrotate
ldconfig
cd ..

# Set Asterisk ownership permissions.
echo -e "\n\033[5;4;47;34m Set Asterisk Permissions \033[0m\n"
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /var/spool/mqueue
chown -R asterisk. /usr/lib64/asterisk
chown -R asterisk. /var/www/

## A few small modifications to Apache.
echo -e "\n\033[5;4;47;34m Some settings for Apache \033[0m\n"
sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf


# Install and Configure FreePBX
echo -e "\n\033[5;4;47;34m Install and Configure FreePBX  \033[0m\n"

rm -f freepbx-15.0-latest.tgz
touch /etc/asterisk/{modules,cdr}.conf
cd freepbx
#sed -i '/AST_USER/s/^#//' /etc/sysconfig/asterisk
#sed -i '/AST_GROUP/s/^#//' /etc/sysconfig/asterisk
./start_asterisk start
./install -n
cd ..


#; systemd startup script for FreePBX
echo -e "\n\033[5;4;47;34m Systemd startup script for FreePBX \033[0m\n"

cat> /etc/systemd/system/freepbx.service <<EOF
[Unit]
Description=FreePBX VoIP Server
After=mariadb.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/fwconsole start -q
ExecStop=/usr/sbin/fwconsole stop -q

[Install]
WantedBy=multi-user.target
EOF

# Startup freepbx
systemctl daemon-reload
systemctl enable freepbx.service
systemctl start freepbx.service
systemctl status -l freepbx.service

# Verify asterisk
systemctl status -l asterisk.service

# Security Warning
fwconsole ma refreshsignatures

# Restart Http
systemctl restart httpd.service

# Upgrade 
fwconsole ma downloadinstall asteriskinfo
fwconsole ma downloadinstall certman
#fwconsole ma upgradeall

# set permissions
fwconsole chown

# Reload services
fwconsole reload

# add firewalld 
echo -e "\n\033[5;4;47;34m Firewalld settings \033[0m\n"

firewall-cmd --permanent --zone=public --add-service={http,https}
firewall-cmd --permanent --zone=public --add-port=5060-5061/tcp
firewall-cmd --permanent --zone=public --add-port=5038/tcp
firewall-cmd --permanent --zone=public --add-port=2000/tcp
firewall-cmd --permanent --zone=public --add-port=8089/tcp
firewall-cmd --permanent --zone=public --add-port=5067/tcp
firewall-cmd --permanent --zone=public --add-port=4520/udp
firewall-cmd --permanent --zone=public --add-port=4569/udp
firewall-cmd --permanent --zone=public --add-port=5000/udp
firewall-cmd --permanent --zone=public --add-port=5060-5061/udp
firewall-cmd --permanent --zone=public --add-port=5067/udp
firewall-cmd --permanent --zone=public --add-port=5160/udp
firewall-cmd --permanent --zone=public --add-port=6000/udp
firewall-cmd --permanent --zone=public --add-port=10000-60000/udp
firewall-cmd --reload

} > install_err.log 2>&1

if [ $(repoquery -a --pkgnarrow=updates |wc -l) -eq 0 ]; then
freepbx
else
echo -e "\n\033[5;4;47;34m Please do "yum update -y" before running the installation \033[0m\n"
echo -e "\n\033[5;4;47;34m Running yum update \033[0m\n"
yum clean all
sleep 3
yum update -y
echo -e "\n\033[5;4;47;34m System Rebooting, Please wait...\033[0m\n"
sleep 5
reboot
fi
