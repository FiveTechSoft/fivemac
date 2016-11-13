#include <fivemac.h>
#import "Quartz/Quartz.h"

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

//-------------------------- el browserItem --------------------------

@interface IKBBrowserItem : NSObject 
{
	
	NSImage * image;
	NSString * imageID;
	
}

- (id)initWithImage:(NSImage *)image imageID:(NSString *)imageID;

@property(readwrite,copy) NSImage * image;
@property(readwrite,copy) NSString * imageID;

- (NSString *) imageUID;
- (NSString *) imageRepresentationType;
- (id) imageRepresentation;

- (NSString*) imageTitle;

@end


@implementation IKBBrowserItem

@synthesize image;
@synthesize imageID;

- (id)initWithImage:(NSImage*)anImage imageID:(NSString*)anImageID
{
    self = [ super init ];
	
	if( self ) 	 {
		image = [anImage copy];
		imageID = [[anImageID lastPathComponent] copy];
	}
	return self;
}

- (void)dealloc
{
	[image release];
	[imageID release];
	[super dealloc];
}


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

- (NSString*) imageTitle
{
	return imageID;
}


@end

//---------------------- el browser -----------------------------------

@interface ImageBrowserView : IKImageBrowserView 
{
   IBOutlet ImageBrowserView * imageBrowser;    
    
   NSMutableArray *browserData;
	
	//para buscar: 
	
   NSMutableArray *filteredOutImages;
	 NSMutableIndexSet *filteredOutIndexes;
}
	
- (IBAction) searchFieldChanged:(id) sender;
	
@end


@implementation ImageBrowserView


- (void) dealloc
{
   [browserData release];
	[filteredOutImages release];
	[super dealloc];
}


#pragma mark - 
#pragma mark Browser Data Source Methods


- (NSUInteger) numberOfItemsInImageBrowser:(ImageBrowserView *) aBrowser
{	
	return [browserData count];
}

- (id) imageBrowser:(ImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index
{
	return [browserData objectAtIndex:index];
}


- (void) addImageWithPath:(NSString *) path
{   
    MyImageObject *item;
    
    NSString *filename = [path lastPathComponent];
	
	/* skip '.*' */ 
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


- (void) imageBrowser:(ImageBrowserView *) aBrowser removeItemsAtIndexes: (NSIndexSet *) indexes
{
	[browserData removeObjectsAtIndexes:indexes];
	[self reloadData];
}

- (BOOL) imageBrowser:(ImageBrowserView *) aBrowser moveItemsAtIndexes: (NSIndexSet *)indexes toIndex:(NSUInteger)destinationIndex
{
	NSArray *tempArray = [browserData objectsAtIndexes:indexes];
	[browserData removeObjectsAtIndexes:indexes];
	 
	destinationIndex -= [indexes countOfIndexesInRange:NSMakeRange(0, destinationIndex)];
	[browserData insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(destinationIndex, [tempArray count])]];
	[self reloadData];
	
	return YES;
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
	browserData = [[NSMutableArray alloc] initWithCapacity:10];
			
	[self setDelegate:self];
	[self setDataSource:self];
	[self setAnimates: YES ];	

}

- (NSUInteger)numberOfSlideshowItems
{
    return [browserData count];
}

// ---------------------------------------------------------------------------------------------------------------------

- (id)slideshowItemAtIndex: (NSUInteger)index
{
    return [[browserData objectAtIndex: index] imageRepresentation];
}

// ---------------------------------------------------------------------------------------------------------------------

- (void)slideshowDidStop
{
    NSUInteger index = [[IKSlideshow sharedSlideshow] indexOfCurrentSlideshowItem];
    [self setSelectionIndexes: [NSIndexSet indexSetWithIndex: index] byExtendingSelection:NO];
}


#pragma mark -
#pragma mark buscar

/* 
 filtrado de imagenes . Depende del valor del search .Dos arrays de imagenes uno con las imagenes filtradas "filteredOutImages" .
  y "filteredOutIndexes" donde se guardan todas las immagenes para devolverlas cuando no hay filtro.
*/

- (BOOL) keyword:(NSString *) aKeyword matchSearch:(NSString *) search
{
    NSRange r = [aKeyword rangeOfString:search options:NSCaseInsensitiveSearch];
     return (r.length>0 );
  //  return (r.length>0 && r.location >= 0);
}


- (IBAction) searchFieldChanged:(id) sender
{
	if(filteredOutImages == nil){
		//first time we use the search field
		filteredOutImages = [[NSMutableArray alloc] init];
		filteredOutIndexes = [[NSMutableIndexSet alloc] init];
	}
	else{
		//restore the original datasource, and restore the initial ordering if possible
		
		NSUInteger lastIndex = [filteredOutIndexes lastIndex];
		if(lastIndex >= [browserData count] + [filteredOutImages count]){
			//can't restore previous indexes, just insert filtered items at the beginning 
			[browserData insertObjects:filteredOutImages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [filteredOutImages count])]];
		}
		else
			[browserData insertObjects:filteredOutImages atIndexes:filteredOutIndexes];
		
		[filteredOutImages removeAllObjects];
		[filteredOutIndexes removeAllIndexes];
	}
	
	//add filtered images to the filteredOut array
	NSString *searchString = [sender stringValue];
	
    if(searchString != nil && [searchString length] > 0){
		int i, n;
		
		n = [browserData count];
		
		for(i=0; i<n; i++){
			MyImageObject *anItem = [browserData objectAtIndex:i];
			
			if([self keyword:[anItem imageTitle] matchSearch:searchString] == NO){
				[filteredOutImages addObject:anItem];
				[filteredOutIndexes addIndex:i];
			}
		}
	}
	
	//remove filtered-out images from the datasource array
	[browserData removeObjectsInArray:filteredOutImages];
	
	//reflect changes in the browser
	[self reloadData];
	
}


- (void) searchFiltro:(NSString *) cBusqueda
{
	if(filteredOutImages == nil){
		//primer uso de la busqueda
		filteredOutImages = [[NSMutableArray alloc] init];
		filteredOutIndexes = [[NSMutableIndexSet alloc] init];
	}
	else{
	
		//volvemos al datasource y orden original 
		
		NSUInteger lastIndex = [filteredOutIndexes lastIndex];
		if(lastIndex >= [browserData count] + [filteredOutImages count]){
			[browserData insertObjects:filteredOutImages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [filteredOutImages count])]];
		}
		else
			[browserData insertObjects:filteredOutImages atIndexes:filteredOutIndexes];
		
		[filteredOutImages removeAllObjects];
		[filteredOutIndexes removeAllIndexes];
	}
	
	//añadimos imagenes al array filtrado
	
	NSString *searchString = cBusqueda ;
	
    if(searchString != nil && [searchString length] > 0){
		int i, n;
		
		n = [browserData count];
		
		for(i=0; i<n; i++){
			MyImageObject *anItem = [browserData objectAtIndex:i];
			
			if([self keyword:[anItem imageTitle] matchSearch:searchString] == NO){
				[filteredOutImages addObject:anItem];
				[filteredOutIndexes addIndex:i];
			}
		}
	}
	
	//se borran las imagenes filtradas del datasource y refrescamos el browser
	
	[browserData removeObjectsInArray:filteredOutImages];
	[self reloadData];
	
}


@end



HB_FUNC( IKIMGBRCREATE )
{

	
	NSScrollView * sv = [ [ NSScrollView alloc ] 
						 initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
	
	[ sv setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
	[ sv setHasVerticalScroller : YES ];
	[ sv setHasHorizontalScroller : YES ];
	[ sv setBorderType : NSBezelBorder ];
	
	 ImageBrowserView	* vista = [ [  ImageBrowserView alloc ] initWithFrame : [ [ sv contentView ] frame ] ];
	
	 NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
	
		
	[ sv setDocumentView : vista ];	
	
	[ GetView( window ) addSubview : sv ];
		 	
	[vista inicia ];
	
	[vista setAllowsReordering:YES ];
	
	// [vista setAnimates: YES ];
	
	//[vista addImagesFromDirectory:@"/Library/Desktop Pictures/Nature/"];
	[vista reloadData];
	
	 hb_retnl( ( HB_LONG ) vista );
}


HB_FUNC( IKIMGBROPENPANEL )
{

       
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
	
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
	
HB_FUNC( IKIMGBROPENDIR )
{
    NSString * path = hb_NSSTRING_par( 2 ) ;
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
	
	[vista addImagesFromDirectory:path ];
}

HB_FUNC( IKIMGBROPENFILE )
{
    NSString * path = hb_NSSTRING_par( 2 ) ;
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
	
    [vista addImageWithPath:path ];
	[vista reloadData];
}


HB_FUNC( IKIMGBROANIMATE )
{
	
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );	
	[vista setAnimates: hb_parnl( 2 )];
}

HB_FUNC( IKIMGBROSTYLE )
{
	
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
	
	[vista setCellsStyleMask: hb_parnl( 2 )];
}

HB_FUNC( IKIMGBROFILTRO )
{
    NSString * filtro = hb_NSSTRING_par( 2 ) ;
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
	
	[vista searchFiltro: filtro];
}

HB_FUNC( IKIMGBROFILTER )
{
	NSObject * filtrador = ( NSObject *) hb_parnl( 2 );
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
	
	[vista searchFieldChanged:filtrador ];
}


HB_FUNC( IKIMGBRSETZOOM )
{
 ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
 [vista setZoomValue: ( hb_parnl( 2 ) /100.0) ];
}

HB_FUNC( IKIMGBRGETZOOM )
{
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
 hb_retnl( ( HB_LONG )([ vista zoomValue ]*100 ) );
}

HB_FUNC( IKIMGRUNSLIDE )

{
	ImageBrowserView * vista = ( ImageBrowserView *) hb_parnl( 1 );
    int index = [[vista selectionIndexes] firstIndex];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt: index], IKSlideshowStartIndex,
                           NULL];
    
    [[IKSlideshow sharedSlideshow] runSlideshowWithDataSource: (id<IKSlideshowDataSource>)vista
                                                       inMode: IKSlideshowModeImages
                                                      options: dict];
}

HB_FUNC( IKIMGSTOPSLIDE )

{
    
   [[IKSlideshow sharedSlideshow] stopSlideshow: [IKSlideshow sharedSlideshow] ];

}

