

# ./build.sh - (c) FiveTech Software 2007-2010

clear

if [ $# = 0 ]; then
   echo syntax: ./build.sh file [options...]
   exit
fi

#echo compiling...
#$HARBPATH/bin/harbour $1 -n -w -I$FIVEPATH/include:$HARBPATH/include $2
#if [ $? = 1 ]; then
#   exit
#fi   

#echo compiling C module...
#HEADERS=$SDKPATH/usr/include

#  add -arch ppc -arch i386 for universal binaries
#gcc $1.c -c -I$FIVEPATH/include -I$HARBPATH/include -I$HEADERS


echo linking...
CRTLIB=$SDKPATH/usr/lib

gcc $1.o -o ./$1.app/Contents/MacOS/$1 -L$CRTLIB -L$FIVEPATH/lib -lfive -lfivec -L$HARBPATH/lib $HRBLIBS $FRAMEWORKS  -F$FIVEPATH/frameworks $EXTRAFRAMEWORKS

echo done!
#./$1.app/Contents/MacOS/$1
# reset
