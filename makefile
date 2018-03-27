# FiveMac makefile (c) FiveTech Software 2008-2015
# Don't use spaces before the rules. Use TABs

OS_VERSION=`sw_vers -productVersion | grep -o 10\..`

# ifeq ( $(OS_VERSION), 10.11 )
	# Yosemite detected
	SDKPATH=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
	HEADERS=$(SDKPATH)/usr/include
	FRAMEPATH=$(SDKPATH)/System/Library/Frameworks
# else
	SDKPATH=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
	HEADERS=$(SDKPATH)/usr/include
    SWIFTFLAGS =  -I../include -sdk $(shell xcrun --show-sdk-path -sdk macosx)
# endif

all : ./lib/libfive.a ./lib/libfivec.a

PRG_OBJS = \
  	./obj/applicat.o \
	./obj/browse.o	\
	./obj/button.o	\
	./obj/btnbmp.o	\
	./obj/brImage.o	\
	./obj/capture.o	\
	./obj/checkbox.o \
   	./obj/code.o \
	./obj/colors.o \
	./obj/colorwell.o \
	./obj/combobox.o \
	./obj/control.o	\
	./obj/coverflow.o \
	./obj/database.o \
	./obj/datepicker.o \
  	./obj/dbtools.o \
	./obj/dialog.o	\
	./obj/errsysm.o \
	./obj/filename.o \
	./obj/folder.o	\
	./obj/folditem.o \
	./obj/font.o \
  	./obj/form.o \
  	./obj/get.o \
	./obj/group.o \
	./obj/harbour.o \
	./obj/image.o \
	./obj/inspect.o \
  	./obj/itunes.o \
   	./obj/locale.o \
  	./obj/mail.o \
  	./obj/memoedit.o \
	./obj/menu.o \
	./obj/menuitem.o \
	./obj/mget.o \
	./obj/movie.o \
  	./obj/multiview.o \
	./obj/nodo.o \
    ./obj/notification.o \
  	./obj/nsobject.o \
  	./obj/picture.o \
  	./obj/printer.o \
	./obj/pdfview.o	\
	./obj/pdmenu.o	\
  	./obj/plist.o	\
	./obj/progres.o \
	./obj/radio.o	\
	./obj/radmenu.o	\
	./obj/outline.o	\
	./obj/say.o	\
	./obj/scintilla.o	\
	./obj/simage.o	\
	./obj/segment.o \
	./obj/settings.o \
	./obj/slider.o \
	./obj/splash.o \
	./obj/split.o \
	./obj/splitItem.o \
  	./obj/strings.o	\
	./obj/sheet.o \
	./obj/Tsound.o \
	./obj/tabview.o \
	./obj/tabItem.o \
    ./obj/tclipget.o \
    ./obj/textbox.o \
	./obj/Ttimer.o	\
	./obj/toolbar.o	\
	./obj/toolbtn.o	\
   	./obj/valblank.o	\
  	./obj/View.o	\
  	./obj/window.o	\
	./obj/webview.o

C_OBJS = ./objc/browses.o	\
	./objc/buttons.o	\
	./objc/checkboxes.o \
	./objc/colors.o \
  	./objc/colorton.o	\
	./objc/comboboxes.o \
	./objc/constants.o \
    ./objc/coverflows.o \
	./objc/cursors.o \
	./objc/datepickers.o \
	./objc/dialogs.o	\
	./objc/encript.o \
	./objc/fonts.o	\
  	./objc/formatters.o	\
  	./objc/funcs.o \
	./objc/gets.o \
	./objc/groups.o \
    ./objc/IKImabr.o \
	./objc/images.o	\
	./objc/ImageAndTextCell.o	\
  	./objc/ituness.o	\
	./objc/menus.o	\
	./objc/mgets.o	\
	./objc/movies.o	\
	./objc/msgs.o	\
	./objc/nibs.o \
    ./objc/notifications.o \
	./objc/objc.o \
	./objc/or.o	\
	./objc/outlines.o	\
  	./objc/pdfviews.o \
  	./objc/popover.o \
	./objc/preferences.o	\
	./objc/printers.o \
	./objc/progress.o \
	./objc/says.o	\
	./objc/scintillas.o	\
	./objc/simages.o	\
  	./objc/searchgets.o	\
  	./objc/segments.o	\
  	./objc/sgets.o \
  	./objc/sheets.o	\
  	./objc/sliders.o	\
  	./objc/sounds.o \
  	./objc/splits.o	\
	./objc/strtoken.o	\
  	./objc/system.o \
	./objc/timers.o	\
  	./objc/tarrays.o	\
	./objc/transparent.o \
	./objc/toolbars.o	\
	./objc/valtochr.o	\
  	./objc/RoundedView.o	\
  	./objc/urls.o	\
  	./objc/tabviews.o	\
  	./objc/views.o \
	./objc/webviews.o \
    ./objc/windows.o

SWIFT_OBJS =


./lib/libfive.a  : $(PRG_OBJS)
#	ranlib ./lib/libfive.a
	
./lib/libfivec.a : $(C_OBJS)
#	ranlib ./lib/libfivec.a

./lib/libfivec.a : $(SWIFT_OBJS)

./obj/%.c : ./source/classes/%.prg
	if [ ! -d "obj" ]; then mkdir obj; fi
	./../harbour/bin/harbour $< -o./$@ -n -I./../harbour/include -I./include

./obj/%.c : ./source/function/%.prg
	if [ ! -d "obj" ]; then mkdir obj; fi
	./../harbour/bin/harbour $< -o./$@ -n -I./../harbour/include -I./include

./objs/%.o : ./source/swift/%.swift
	if [ ! -d "objs" ]; then mkdir objs; fi
	swiftc -frontend -c -color-diagnostics -primary-file $<  \
	-module-name Bridgette \
	$(SWIFTFLAGS) -emit-module -emit-module-path ./source/swift/$*.swiftmodule \
	-emit-objc-header-path ./source/swift/$*-Swift.h \
	-enable-testing -enable-objc-interop -parse-as-library \
	-o $@
	if [ ! -d "lib" ]; then mkdir lib; fi
	ar rc ./lib/libfivec.a $@

# -arch i386 -arch ppc
./obj/%.o : ./obj/%.c
	gcc -c -o $@ -I./../harbour/include -I$(HEADERS) -F$(FRAMEPATH) $< 
	if [ ! -d "lib" ]; then mkdir lib; fi	
	ar rc ./lib/libfive.a $@ 

# -arch i386 -arch ppc
./objc/%.o : ./source/function/%.c
	if [ ! -d "objc" ]; then mkdir objc; fi
	gcc -I./../harbour/include -I./include -I$(HEADERS) -F$(FRAMEPATH) -Wall -c -o $@ $<
	if [ ! -d "lib" ]; then mkdir lib; fi
	ar rc ./lib/libfivec.a $@

# -arch i386 -arch ppc
./objc/%.o : ./source/winapi/%.m
	if [ ! -d "objc" ]; then mkdir objc; fi
	gcc -I./../harbour/include -I./include -I$(HEADERS) -Wall -c -o $@ $<
	if [ ! -d "lib" ]; then mkdir lib; fi
	ar rc ./lib/libfivec.a $@

# -arch i386 -arch ppc
./objc/%.o : ./source/internal/%.c
	if [ ! -d "objc" ]; then mkdir objc; fi
	gcc -I./../harbour/include -I./include -I$(HEADERS) -F$(FRAMEPATH) -Wall -c -o $@ $<
	if [ ! -d "lib" ]; then mkdir lib; fi
	ar rc ./lib/libfivec.a $@

# -arch i386 -arch ppc
./objc/%.o : ./source/internal/%.m 
	if [ ! -d "objc" ]; then mkdir objc; fi
	gcc -I./../harbour/include -I./include -I$(HEADERS) -F$(FRAMEPATH) -Wall -c -o $@ $<
	if [ ! -d "lib" ]; then mkdir lib; fi
	ar rc ./lib/libfivec.a $@

clean:
	rm ./obj/*
	rm ./objc/*
