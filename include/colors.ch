// FiveWin Graphical Enviroments RGB colors management

#ifndef _COLORS_CH
#define _COLORS_CH

#translate RGB( <nRed>, <nGreen>, <nBlue> ) => ;
              ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )

#translate ARGB( <nAlpha>, <nRed>, <nGreen>, <nBlue> ) => ;
( <nBlue> + ( <nGreen> * 256 ) + ( <nRed> * 65536 ) ) + ( <nAlpha> * 16777216 )


//����������������������������������������������������������������������������//
//                        Low Intensity colors
//����������������������������������������������������������������������������//

#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY CLR_HGRAY
#define CLR_PANE         174250               // RGB( 170, 170, 170 )

//����������������������������������������������������������������������������//
//                       High Intensity Colors
//����������������������������������������������������������������������������//

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
#define CLR_HRED            255               // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )

//����������������������������������������������������������������������������//
//                       Metro Colors
//����������������������������������������������������������������������������//

#define METRO_LIME    RGB(164, 196, 0)
#define METRO_GREEN   RGB(96, 169, 23)
#define METRO_EMERALD RGB(0, 138, 0)
#define METRO_TEAL    RGB(0, 171, 169)
#define METRO_CYAN    RGB(27, 161, 226)
#define METRO_COBALT  RGB(0, 80, 239)
#define METRO_INDIGO  RGB(106, 0, 255)
#define METRO_VIOLET  RGB(170, 0, 255)
#define METRO_PINK    RGB(244, 114, 208)
#define METRO_MAGENTA RGB(216, 0, 115)
#define METRO_CRIMSON RGB(162, 0, 37)
#define METRO_RED     RGB(229, 20, 0)
#define METRO_ORANGE  RGB(250, 104, 0)
#define METRO_AMBER   RGB(240, 163, 10)
#define METRO_YELLOW  RGB(227, 200, 0)
#define METRO_BROWN   RGB(130, 90, 44)
#define METRO_OLIVE   RGB(109, 135, 100)
#define METRO_STEEL   RGB(100, 118, 135)
#define METRO_MAUVE   RGB(118, 96, 138)
#define METRO_TAUPE   RGB(135, 121, 78)


#endif
