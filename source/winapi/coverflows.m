#include <fivemac.h>
#import "Quartz/Quartz.h"

@interface IKImageFlowView : NSOpenGLView
{
   id _dataSource;
   id _dragDestinationDelegate;
   id _delegate;
   void * _reserved;
}

+ ( id ) pixelFormat;
+ ( BOOL ) flowViewIsSupportedByCurrentHardware;
+ ( void ) initialize;
+ ( void ) setImportAnimationStyle : ( unsigned int ) fp8;
- ( void ) _setDefaultTextAttributes;
- ( void ) _ikCommonInit;
//- (id)initWithFrame:(struct _NSRect)fp8;
- ( void ) dealloc;
- ( void ) finalize;
- ( void ) setValue : ( id ) fp8 forUndefinedKey : ( id ) fp12;
- ( id ) valueForUndefinedKey : ( id ) fp8;
- ( id ) allocateNewCell;
- ( void ) dataSourceDidChange;
- ( void ) _reloadCellDataAtIndex : ( int ) fp8;
- ( void ) reloadCellDataAtIndex : ( int ) fp8;
- ( void ) reloadAllCellsData;
- ( void ) reloadData;
- ( id ) loadCellAtIndex : ( int ) fp8;
- ( void ) didStabilize;
- ( BOOL ) isAnimating;
- ( void ) setAnimationsMask : ( unsigned int ) fp8;
- ( unsigned int ) animationsMask;
- ( void ) _cellFinishedImportAnimation : ( id ) fp8;
- ( BOOL ) itemAtIndexIsLoaded : ( unsigned int )fp8;
- ( void ) keyWindowChanged : ( id ) fp8;
- (void)setSelectedIndex:(unsigned int)fp8;
- (BOOL)hitTestWithImage:(id)fp8 x:(float)fp12 y:(float)fp16;
- (unsigned int)cellIndexAtLocation:(struct _NSPoint)fp8;
- (void)_adjustScroller;
- (void)resetCursorRects;
- (void)frameDidChange:(id)fp8;
- (void)invalidateLayout;
- (float)offset;
- (int)cellIndexAtPosition:(float)fp8;
- (int)heightOfInfoSpace;
- (int)countOfVisibleCellsOnEachSide;
- (struct _NSRange)rangeOfVisibleIndexes;
- (struct _NSRange)rangeOfVisibleIndexesAtSelection;
- (id)visibleCellIndexesAtSelection;
- (id)visibleCellIndexes;
- (void)flipCellsWithOldSelectedIndex:(unsigned int)fp8 newSelectedIndex:(unsigned int)fp12;
- (void)flowLayout:(struct _NSRange)fp8;
- (void)zoomOnSelectedLayerLayout:(struct _NSRange)fp8;
- (void)updateLayoutInRange:(struct _NSRange)fp8;
- (void)updateLayout;
- (struct _NSRect)titleFrame;
- (struct _NSRect)subtitleFrame;
- (struct _NSRect)splitterFrame;
- (double)_viewAspectRatio;
- (double)_zScreen;
- (struct _NSSize)imageRenderedSize;
- (struct _NSRect)selectedImageFrame;
- (double)_computeCameraDZ;
- (double)cameraDZ;
- (double)_computeCameraDY;
- (double)cameraDY;
- (float)convertPixelUnitTo3DUnit:(float)fp8;
- (double)alignOnPixelValue;
- (BOOL)updatesCGSurfaceOnDrawRect;
- (void)setUpdatesCGSurfaceOnDrawRect:(BOOL)fp8;
- (BOOL)showSplitter;
- (void)setShowSplitter:(BOOL)fp8;
- (id)delegate;
- (void)setDelegate:(id)fp8;
- (id)dataSource;
- (void)setDataSource:(id)fp8;
- (void)setZoomOnSelectedLayer:(BOOL)fp8;
- (BOOL)zoomOnSelectedLayer;
- (unsigned int)itemsCount;
- (id)cells;
- (unsigned int)selectedIndex;
- (unsigned int)focusedIndex;
- (id)backgroundColor;
- (void)_setBackgroundColorWithRed:(float)fp8 green:(float)fp12 blue:(float)fp16 alpha:(float)fp20;
- (BOOL)backgroundIsLight;
- (BOOL)backgroundIsBlack;
- (BOOL)_convertColor:(id)fp8 toRed:(float *)fp12 green:(float *)fp16 blue:(float *)fp20 alpha:(float *)fp24;
- (void)_getBackgroundRed:(float *)fp8 green:(float *)fp12 blue:(float *)fp16 alpha:(float *)fp20;
- (void)setBackgroundColor:(id)fp8;
- (id)cellBackgroundColor;
- (void)setCellBackgroundColor:(id)fp8;
- (id)cellBorderColor;
- (void)setCellBorderColor:(id)fp8;
- (float)imageAspectRatio;
- (void)setImageAspectRatio:(float)fp8;
- (float)scaleFactor;
- (id)cacheManager;
- (BOOL)cellsAlignOnBaseline;
- (void)setCellsAlignOnBaseline:(BOOL)fp8;
- (void)startInlinePreview;
- (void)stopInlinePreview;
- (void)inlinePreviewDidRenderImage:(void *)fp8;
- (id)thumbnailImageAtIndex:(int)fp8;
- (id)previewImageAtIndex:(int)fp8;
- (void)initRenderingContext;
- (void *)fogShader;
- (void)renewGState;
- (void)setHidden:(BOOL)fp8;
- (id)renderer;
- (void)_setAutoscalesBoundsToPixelUnits:(BOOL)fp8;
- (void)setCacheManager:(id)fp8;
- (id)imageFlowContext;
- (void)setImageFlowContext:(id)fp8;
- (void)__ikSetupGLContext:(id)fp8;
- (id)openGLContext;
- (void)setOpenGLContext:(id)fp8;
- (void)_cacheWasFlushed:(id)fp8;
- (float)fogAtLocation:(float)fp8;
- (struct _NSRect)clampedBounds;
- (struct _NSRect)clampedFrame;
- (void)drawVisibleCells:(struct _NSRect)fp8;
- (void)drawBackground;
- (void)drawTitle;
- (BOOL)installViewport;
- (void)setupGLState;
- (void)installPerspetiveViewportForPicking:(BOOL)fp8 location:(struct _NSPoint)fp12;
- (void)drawFocusRing;
- (BOOL)drawWithCurrentRendererInRect:(struct _NSRect)fp8;
- (void)__copyPixels:(void *)fp8 withSize:(struct _NSSize)fp12 toCurrentFocusedViewAtPoint:(struct _NSPoint)fp20;
- (void)__copyGLToCurrentFocusedView;
- (BOOL)_createPBuffer;
- (void)_deletePBUffer;
- (BOOL)_installPBuffer;
- (void)_copyPBufferToCGSurface;
- (void)drawRect:(struct _NSRect)fp8;

@end



static NSArray *openFiles()
{ 
    NSOpenPanel *panel;
	panel = [NSOpenPanel openPanel];        
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
	int i = [panel runModal ];
	if(i == NSModalResponseOK){
       return [panel URLs];
    }
    
    return nil;
}  

@interface MyImageObject : NSObject{
    NSString *path; 
}
@end

@implementation MyImageObject

- (void) dealloc
{
    [path release];
    [super dealloc];
}

- (void) setPath:(NSString *) aPath
{
    if(path != aPath){
        [path release];
        path = [aPath retain];
    }
}

#pragma mark -
#pragma mark item data source protocol

- (NSString *)  imageRepresentationType
{
	return IKImageBrowserPathRepresentationType;
}

- (id)  imageRepresentation
{
	return path;
}

- (NSString *) imageUID
{
    return path;
}

- (id) imageTitle
{
	return [path lastPathComponent];
}

@end


@interface IKBBrowserItem : NSObject 
{
	
	NSImage * image;
	NSString * imageID;
	NSString * fullImagePath;
}

- (id)initWithImage:(NSImage *)image imageID:(NSString *)imageID;

@property(readwrite,copy) NSImage * image;
@property(readwrite,copy) NSString * imageID;
@property(readwrite,copy) NSString * fullImagePath;

#pragma mark -
#pragma mark Required Methods IKImageBrowserItem Informal Protocol
- (NSString *) imageUID;
- (NSString *) imageRepresentationType;
- (id) imageRepresentation;

#pragma mark -
#pragma mark Optional Methods IKImageBrowserItem Informal Protocol
- (NSString*) imageTitle;

@end


@implementation IKBBrowserItem

@synthesize image;
@synthesize imageID, fullImagePath;


- (id)initWithImage:(NSImage*)anImage imageID:(NSString*)anImageID
{
	self = [ super init ];
	
	if( self ) 
  {
		image = [anImage copy];
		imageID = [[anImageID lastPathComponent] copy];
		fullImagePath = [anImageID copy];
	}
	return self;
}

- (void)dealloc
{
	[image release];
	[imageID release];
	[fullImagePath release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Required Methods IKImageBrowserItem Informal Protocol
- (NSString *) imageUID
{
	return imageID;
}
- (NSString *) imageRepresentationType
{
	return IKImageBrowserNSImageRepresentationType;
}
- (id) imageRepresentation
{
	return image;
}

#pragma mark -
#pragma mark Optional Methods IKImageBrowserItem Informal Protocol
- (NSString*) imageTitle
{
	return imageID;
}

@end


@interface IKBImageFlowView : IKImageFlowView {
	
	NSMutableArray * browserData;
	
}

@end




@implementation IKBImageFlowView

- (void) dealloc
{
    [browserData release];
	[super dealloc];
}


- (void)inicial
{
	//Allocate some space for the data source
	browserData = [[NSMutableArray alloc] initWithCapacity:10];
	
	//Browser UI setup (can also be set in IB)
	[self setDelegate:self];
	[self setDataSource:self];
		
}

#pragma mark - 
#pragma mark Cover Flow Data Source Methods

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1050
   - ( unsigned int ) numberOfItemsInImageFlow:(id) aBrowser
#else
   - ( NSUInteger ) numberOfItemsInImageFlow:(id) aBrowser
#endif
{
	return [browserData count];
}

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1050
   - (id) imageFlow:(IKBImageFlowView *) aBrowser itemAtIndex: ( unsigned int ) index
#else
   - (id) imageFlow:(IKBImageFlowView *) aBrowser itemAtIndex: ( NSUInteger ) index
#endif
{
	return [browserData objectAtIndex:index];
}

- (void) addImageWithPath:(NSString *) path
{   
    MyImageObject *item;
    
    NSString *filename = [path lastPathComponent];
	
	
	if([filename length] > 0){
		char *ch = (char*) [filename UTF8String];
		
		if(ch)
			if(ch[0] == '.')
				return;
	}
	
	item = [[MyImageObject alloc] init];	
	[item setPath:path];
	[browserData addObject:item];
	[item release];
}

- (void) addImagesFromDirectory:(NSString *) path
{
    int i, n;
    BOOL dir;
	
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
    
    if(dir){
        NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
		
        n = [content count];
        
        for(i=0; i<n; i++)
			[self addImageWithPath:[path stringByAppendingPathComponent:[content objectAtIndex:i]]];
    }
    else
        [self addImageWithPath:path];
	
	[self reloadData];
}

- (void) inicia
{
	//Allocate some space for the data source
	browserData = [[NSMutableArray alloc] initWithCapacity:10];
	
	//Browser UI setup (can also be set in IB)
	[self setDelegate:self];
	[self setDataSource:self];
	//[browserView setDraggingDestinationDelegate:self];
	
}


@end



HB_FUNC( IKCOVERCREATE )
{
	
	 IKBImageFlowView	* vista = [ [  IKBImageFlowView alloc ] initWithFrame :NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
							
     NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
			
		
	[ GetView( window ) addSubview : vista ];
	 	
	[vista inicial ];
    
//	[vista setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
	
//	[vista addImagesFromDirectory:@"/Library/Desktop Pictures/Nature/"];
//	[vista reloadData];
	
	 hb_retnl( ( HB_LONG ) vista );
	
}



HB_FUNC( IKCOVERINICIAL )
{
	IKBImageFlowView * vista = (  IKBImageFlowView *) hb_parnl( 1 );
	[vista inicial ];
    
    }


HB_FUNC( IKCOVEROPENDIR )
{
	NSString * path = hb_NSSTRING_par( 2 ) ;
    IKBImageFlowView * vista = (  IKBImageFlowView *) hb_parnl( 1 );
	
	[vista addImagesFromDirectory:path ];
	[vista reloadData];
}	

HB_FUNC( IKCOVERAJUST )
{
	IKBImageFlowView * vista = (  IKBImageFlowView *) hb_parnl( 1 );
	[vista setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
    
}

HB_FUNC( IKCOVEROPENFILE )
{
	NSString * path = hb_NSSTRING_par( 2 ) ;
	IKBImageFlowView * vista = ( IKBImageFlowView *) hb_parnl( 1 );
	
	[vista addImageWithPath:path ];
	[vista reloadData];
}

HB_FUNC( IKCOVEROPENPANEL )
{
	
	IKBImageFlowView  * vista = ( IKBImageFlowView  *) hb_parnl( 1 );
	
	NSArray *path = openFiles();
    
	
    if(!path){ 
        NSLog(@"No path selected, return..."); 
        return; 
    }
	
	int i, n;
	
	n = [path count];
	
	for( i = 0; i < n; i++ )
		[ vista addImagesFromDirectory:  [[ path objectAtIndex: i ]  path] ];
	
	[vista reloadData];
}

