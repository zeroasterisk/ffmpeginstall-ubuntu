#!/bin/bash
#
# ffmpeginstall-ubuntu
#
# this sctipt downloads and install ffmpeg and x264 from git for the initial install
#
# Moved to github for simpler tracking/updating/etc
# https://github.com/zeroasterisk/ffmpeginstall-ubuntu
#
# History
#  script taken from the primary install script:
#    http://code.google.com/p/x264-ffmpeg-up-to-date/
#  which was taken from the excellent tutorial found here:
#    http://ubuntuforums.org/showthread.php?t=786095
#      "all props to fakeoutdoorsman"
#

INSTALL="/usr/local/src"
# location of log file
LOG="/var/log/ffmpeginstall-ubuntu.log"
# location of the script's lock file
LOCK="/var/run/ffmpeginstall-ubuntu.pid"
SCRIPT="ffmpeginstall-ubuntu.sh"

#oneiric install
oneiric_dep () {
apt-get -y remove ffmpeg x264 libx264-dev  libvpx0 libvpx-dev 2>> $LOG >> $LOG
apt-get -y update 2>> $LOG >> $LOG
apt-get -y install build-essential checkinstall git libfaac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev texi2html yasm zlib1g-dev 2>> $LOG >> $LOG
}
oneiric_x264 () {
generic_install_x264
}
oneiric_libvpx () {
generic_install_libvpx
}
oneiric_ffmpeg () {
generic_install_ffmpeg
}


#natty install
natty_dep ()
{
apt-get -y remove ffmpeg x264 libx264-dev libvpx 2>> $LOG >> $LOG
apt-get -y update 2>> $LOG >> $LOG
apt-get -y install build-essential checkinstall git libfaac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev texi2html yasm zlib1g-dev 2>> $LOG >> $LOG
}

natty_x264 () {
generic_install_x264
}
natty_libvpx () {
generic_install_libvpx
}
natty_ffmpeg () {
generic_install_ffmpeg
}

#maverick install
maverick_dep ()
{
apt-get -y remove ffmpeg x264 libx264-dev libvpx 2>> $LOG >> $LOG
apt-get -y update 2>> $LOG >> $LOG
apt-get -y install build-essential git-core checkinstall yasm texi2html libfaac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev zlib1g-dev 2>> $LOG >> $LOG
}

maverick_x264 () {
generic_install_x264
}
maverick_libvpx () {
generic_install_libvpx
}
maverick_ffmpeg () {
generic_install_ffmpeg
}

#lucid install
lucid_dep ()
{
apt-get -y remove ffmpeg x264 libx264-dev libvpx 2>> $LOG >> $LOG
apt-get -y update 2>> $LOG >> $LOG
apt-get -y install build-essential git-core checkinstall yasm texi2html libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev zlib1g-dev 2>> $LOG >> $LOG
#install LAME
cd $INSTALL
apt-get -y remove libmp3lame-dev 2>> $LOG >> $LOG
apt-get -y install nasm 2>> $LOG >> $LOG
wget http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz 2>> $LOG >> $LOG
tar xzvf lame-3.98.4.tar.gz 2>> $LOG >> $LOG
cd lame-3.98.4 2>> $LOG >> $LOG
./configure --enable-nasm --disable-shared 2>> $LOG >> $LOG
make -j $NO_OF_CPUCORES 2>> $LOG >> $LOG
checkinstall --pkgname=lame-ffmpeg --pkgversion="3.98.4" --backup=no --default --deldoc=yes 2>> $LOG >> $LOG
}

lucid_x264 () {
generic_install_x264
}
lucid_libvpx () {
generic_install_libvpx
}
lucid_ffmpeg () {
generic_install_ffmpeg
}

#generic functions
generic_install_x264 ()
{
cd $INSTALL
git clone git://git.videolan.org/x264.git 2>> $LOG >> $LOG
cd x264
./configure --enable-static 2>> $LOG >> $LOG
make -j $NO_OF_CPUCORES 2>> $LOG >> $LOG
X264V=$(./version.sh | awk -F'[" ]" /POINT/{print $4"+git"$5}')
#checkinstall --pkgname=x264 --default --pkgversion="3:$X264V" --backup=no --deldoc=yes 2>> $LOG >> $LOG
checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes --fstrans=no --default 2>> $LOG >> $LOG\
hash x264 2>> $LOG >> $LOG
}
generic_install_libvpx ()
{
cd $INSTALL
rm -rf libvpx
git clone http://git.chromium.org/webm/libvpx.git  2>> $LOG >> $LOG
cd libvpx
./configure  2>> $LOG >> $LOG
make clean 2>> $LOG >> $LOG
make -j $NO_OF_CPUCORES 2>> $LOG >> $LOG
checkinstall --pkgname=libvpx --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --default --deldoc=yes  2>> $LOG >> $LOG
ldconfig 2>> $LOG >> $LOG
}
generic_install_ffmpeg ()
{
cd $INSTALL
rm -rf ffmpeg
git clone git://git.videolan.org/ffmpeg 2>> $LOG >> $LOG
cd ffmpeg
./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxvid --enable-x11grab 2>> $LOG >> $LOG
make clean 2>> $LOG >> $LOG
make -j $NO_OF_CPUCORES 2>> $LOG >> $LOG
#checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" --backup=no --deldoc=yes --fstrans=no --default 2>> $LOG >> $LOG
checkinstall --pkgname=ffmpeg --pkgversion="5:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default  2>> $LOG >> $LOG
hash x264 ffmpeg ffplay ffprobe 2>> $LOG >> $LOG
ldconfig
#make tools/qt-faststart
#checkinstall --pkgname=qt-faststart --pkgversion="$(./version.sh)" --backup=no --deldoc=yes --default install -D -m755 tools/qt-faststart /usr/local/bin/qt-faststart
}
#exit function
die ()
{
	echo $@
	killall $SCRIPT
	exit 1
}

#error function
error ()
{
	kill "$PID" &>/dev/null 2>> $LOG >> $LOG

	echo $1
	echo $@
	killall $SCRIPT
	exit 1
}


###############
# this is the body of the script
###############


# Speed up build time using multpile processor cores.
NO_OF_CPUCORES=`grep -c ^processor /proc/cpuinfo 2>/dev/null`
if [ ! "$?" = "0" ]; then
    NO_OF_CPUCORES=2
fi

#this script must be run as root, so lets check that
echo "test"
if [ "$(id -u)" != "0" ]; then
   echo "exiting. This script must be run as root" 1>&2
   exit 1
fi


#first, lets warn the user use of this script requires some common sense and may mess things up
echo "WARNING, if you don't know what this script does"
echo "#-#-#-#-#-#-#-#-#-DO NOT RUN IT-#-#-#-#-#-#-#-#-#"
read -p "Continue (y/n)?"
[ "$REPLY" == y ] || die "exiting (chicken ;) )..."
echo

#next, lets find out what version of Ubuntu we are running and check it
DISTRO=( $(cat /etc/lsb-release | grep CODE | cut -c 18-) )
OKDISTRO="hardy karmic lucid maverick helena isadora julia natty oneiric"

if [[ ! $(grep $DISTRO <<< $OKDISTRO) ]]; then
  die "exiting. Your distro is not supported, sorry.";
fi

DISTRIB=( $(cat /etc/lsb-release | grep ID | cut -c 12-) )

echo "Please note, earlier versions of Linux Mint appear as Ubuntu.."
read -p "You are running $DISTRIB $DISTRO, is this correct (y/n)?"
[ "$REPLY" == y ] || die "Sorry, I think you are using a different distro, exiting to be safe."
echo

# check that the default place to download to and log file location is ok
echo "This script downloads the source files to:"
echo "$INSTALL"
read -p "Is this ok (y/n)?"
[ "$REPLY" == y ] || die "exiting. Please edit the script changing the INSTALL variable to the location of your choice."
echo

echo "This script logs to:"
echo "$LOG"
read -p "Is this ok (y/n)?"
[ "$REPLY" == y ] || die "exiting. Please edit the script changing the LOG variable to the location of your choice."
echo

# ok, already, last check before proceeding
echo "OK, we are ready to rumble."
read -p "Shall I proceed, remember, this musn't be stopped (y/n)?"
[ "$REPLY" == y ] || die "exiting. Bye, did I come on too strong?."

echo
echo "Lets roll!"
echo "script started" > $LOG
rm -rf "$INSTALL"/x264
rm -rf "$INSTALL"/libvpx
rm -rf "$INSTALL"/ffmpeg
echo "installing dependencies"
echo "installing dependencies" 2>> $LOG >> $LOG
"$DISTRO"_dep || error "Sorry something went wrong installing dependencies, please check the $LOG file." &
PID=$!
#this is a simple progress indicator
while ps |grep $PID &>/dev/null; do
	echo -n "."
	echo -en "\b-"
	sleep 1
	echo -en "\b\\"
	sleep 1
	echo -en "\b|"
	sleep 1
	echo -en "\b/"
	sleep 1
done



echo -e "\bDone"
echo
echo "downlading, building and installing x264"
echo "downlading, building and installing x264" 2>> $LOG >> $LOG
"$DISTRO"_x264 || error "Sorry something went wrong installing x264, please check the $LOG file." &
PID=$!
#this is a simple progress indicator
while ps |grep $PID &>/dev/null; do
	echo -n "."
	echo -en "\b-"
	sleep 1
	echo -en "\b\\"
	sleep 1
	echo -en "\b|"
	sleep 1
	echo -en "\b/"
	sleep 1
done

#verify
if [ ! -f /usr/local/lib/libx264.so ];
then
    die "exiting. Sorry, unable to find /usr/local/lib/libx264.so (it should have just been installed)";
fi

echo -e "\bDone"
echo
echo "downlading, building and installing libvpx"
echo "downlading, building and installing libvpx" 2>> $LOG >> $LOG
"$DISTRO"_libvpx || error "Sorry something went wrong installing libvpx, please check the $LOG file." &
PID=$!
#this is a simple progress indicator
while ps |grep $PID &>/dev/null; do
	echo -n "."
	echo -en "\b-"
	sleep 1
	echo -en "\b\\"
	sleep 1
	echo -en "\b|"
	sleep 1
	echo -en "\b/"
	sleep 1
done

#verify
if [ ! -f /usr/local/lib/libvpx.a ];
then
    die "exiting. Sorry, unable to find /usr/local/lib/libvpx.a (it should have just been installed)";
fi

echo -e "\bDone"
echo
echo "downloading, building and installing FFmpeg"
echo "downloading, building and installing FFmpeg" 2>> $LOG >> $LOG
"$DISTRO"_ffmpeg || error "Sorry something went wrong installing FFmpeg, please check the $LOG file." &
PID=$!
#this is a simple progress indicator
while ps |grep $PID &>/dev/null; do
	echo -n "."
	echo -en "\b-"
	sleep 1
	echo -en "\b\\"
	sleep 1
	echo -en "\b|"
	sleep 1
	echo -en "\b/"
	sleep 1
done

#verify
if [ ! -f /usr/local/bin/ffmpeg ];
then
    die "exiting. Sorry, unable to find /usr/local/bin/ffmpeg (it should have just been installed)";
fi

echo -e "\bDone"
echo
echo "That's it, all done."
echo "Take a look at the install log, for full details of what was done"
echo "  less $LOG"
echo "exiting now, bye."
echo "You may re-run this script anytime to remove/install ffmpegup to the latest"
exit
