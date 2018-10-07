/*
 * Harbour 3.2.0dev (r1704061005)
 * LLVM/Clang C 8.1 (clang-802.0.41) (64-bit)
 * Generated C source from "testcolor.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( MAIN );
HB_FUNC_EXTERN( NRGB );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( COLORFROMNRGB );
HB_FUNC_EXTERN( COLORFROMNRGB2 );
HB_FUNC_EXTERN( GETCOLORRGB );
HB_FUNC_EXTERN( GETBLUENSCOLOR );
HB_FUNC_EXTERN( GETBLUENSCOLOR2 );
HB_FUNC_EXTERN( TWINDOW );
HB_FUNC_EXTERN( TCOLORWELL );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC( BTNCLICK );
HB_FUNC_EXTERN( HB_GT_NUL_DEFAULT );
HB_FUNC_EXTERN( ERRORLINK );
HB_FUNC_EXTERN( MSGBEEP );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TESTCOLOR )
{ "MAIN", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( MAIN )}, NULL },
{ "NRGB", {HB_FS_PUBLIC}, {HB_FUNCNAME( NRGB )}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "COLORFROMNRGB", {HB_FS_PUBLIC}, {HB_FUNCNAME( COLORFROMNRGB )}, NULL },
{ "COLORFROMNRGB2", {HB_FS_PUBLIC}, {HB_FUNCNAME( COLORFROMNRGB2 )}, NULL },
{ "GETCOLORRGB", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETCOLORRGB )}, NULL },
{ "GETBLUENSCOLOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETBLUENSCOLOR )}, NULL },
{ "GETBLUENSCOLOR2", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETBLUENSCOLOR2 )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( TWINDOW )}, NULL },
{ "CENTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCOLORWELL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCOLORWELL )}, NULL },
{ "GETCOLOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCOLOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BTNCLICK", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( BTNCLICK )}, NULL },
{ "OCLR", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_GT_NUL_DEFAULT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_GT_NUL_DEFAULT )}, NULL },
{ "ERRORLINK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORLINK )}, NULL },
{ "MSGBEEP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGBEEP )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TESTCOLOR, "testcolor.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TESTCOLOR
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TESTCOLOR )
   #include "hbiniseg.h"
#endif

HB_FUNC( MAIN )
{
	static const HB_BYTE pcode[] =
	{
		13,6,0,36,15,0,176,1,0,92,100,93,200,0,
		92,110,12,3,80,2,36,18,0,176,2,0,95,2,
		4,1,0,89,15,0,1,0,0,0,176,3,0,95,
		1,12,1,6,20,2,36,20,0,176,4,0,95,2,
		12,1,80,4,36,21,0,176,5,0,92,100,93,200,
		0,92,110,12,3,80,5,36,23,0,176,2,0,176,
		6,0,95,4,12,1,4,1,0,89,15,0,1,0,
		0,0,176,3,0,95,1,12,1,6,20,2,36,25,
		0,176,2,0,176,6,0,95,5,12,1,4,1,0,
		89,15,0,1,0,0,0,176,3,0,95,1,12,1,
		6,20,2,36,27,0,176,2,0,176,7,0,95,4,
		12,1,4,1,0,89,15,0,1,0,0,0,176,3,
		0,95,1,12,1,6,20,2,36,28,0,176,2,0,
		176,8,0,95,4,12,1,4,1,0,89,15,0,1,
		0,0,0,176,3,0,95,1,12,1,6,20,2,36,
		31,0,48,9,0,176,10,0,12,0,92,20,92,100,
		93,184,1,93,88,2,106,11,84,69,83,84,32,99,
		111,108,111,114,0,100,100,100,100,100,100,100,100,106,
		5,111,87,110,100,0,112,14,80,1,36,33,0,48,
		11,0,95,1,112,0,73,36,36,0,48,9,0,176,
		12,0,12,0,92,100,92,60,92,100,92,30,95,1,
		89,17,0,0,0,1,0,6,0,48,13,0,95,255,
		112,0,6,112,6,80,6,36,38,0,48,14,0,95,
		6,95,2,112,1,73,36,42,0,48,9,0,176,15,
		0,12,0,92,2,93,200,0,100,100,106,3,111,107,
		0,95,1,89,22,0,1,0,1,0,6,0,176,3,
		0,48,13,0,95,255,112,0,12,1,6,100,100,100,
		100,100,106,6,111,98,116,110,49,0,112,13,80,3,
		36,46,0,48,9,0,176,15,0,12,0,92,2,93,
		144,1,100,100,106,6,83,97,108,105,114,0,95,1,
		89,17,0,1,0,1,0,1,0,48,16,0,95,255,
		112,0,6,100,100,100,100,100,106,6,111,98,116,110,
		49,0,112,13,80,3,36,51,0,48,17,0,95,1,
		100,100,9,100,9,100,100,100,112,8,73,36,54,0,
		100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( BTNCLICK )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,57,0,48,13,0,109,19,0,112,0,
		80,1,36,58,0,176,3,0,95,1,20,1,36,59,
		0,48,14,0,109,19,0,95,1,112,1,73,36,60,
		0,48,20,0,109,19,0,112,0,73,36,62,0,100,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}
