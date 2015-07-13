# FiveMac makefile sample (c) FiveTech Software 2007-2015
# Use TABs instead of spaces
# just type make to build it

all : ./one.app/Contents/MacOS/one
	./one.app/Contents/MacOS/one
	reset
    
PRG_OBJS = ./one.o  \
	./two.o \
	./three.o   \

./one.app/Contents/MacOS/one : $(PRG_OBJS)
	if [ ! -d one.app ]; then mkdir one.app; fi
	if [ ! -d one.app/Contents ]; then mkdir one.app/Contents; fi
	if [ ! -d one.app/Contents/MacOS ]; then mkdir one.app/Contents/MacOS; fi
	gcc one.o two.o three.o -o ./one.app/Contents/MacOS/one -L./../lib -lfive -lfivec -L./../../harbour/lib -lhbdebug -lhbvm -lhbrtl -lhblang -lhbrdd -lhbrtl -lgtstd -lgttrm -lhbvm -lhbmacro -lhbpp -lrddntx -lrddcdx -lrddfpt -lhbsix -lhbcommon -framework Cocoa

./%.c : ./%.prg
	./../../harbour/bin/harbour $< -o./$@ -n -I./../../harbour/include -I./../include

./%.o : ./%.c
	gcc -c -o $@ -I./../../harbour/include $< 


 