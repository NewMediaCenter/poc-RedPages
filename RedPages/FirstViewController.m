//
//  FirstViewController.m
//  RedPages
//
//  Created by Jerrad Thramer on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize directoryConnnection;
@synthesize rawResponse;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"THIS WORKS");
    NSString *searchQueryURL = [NSString stringWithFormat:
                              @"http://directory.unl.edu/service.php?q=%@&format=xml",[[searchBar text] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *queryRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchQueryURL]];
    [self setDirectoryConnnection:[[NSURLConnection alloc] initWithRequest:queryRequest delegate:self startImmediately:YES]];
    if (self.directoryConnnection == nil)
    {
        // do stuff
    }
    [searchActive startAnimating];
    
    
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    //add incoming data to NSMutableData dataarray.
    NSLog(@"Recieved Data!");
    [rawResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Raw Data: %@", rawResponse);
    
    // lets create it and give it some data
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:rawResponse];
    // we want the messages
    [parser setDelegate:self];
    //lets have it start parsing
    [parser parse];
    
    //now that its done, we can release it
    //[parser release]; ~~ DEPRECATED WITH ARC
    
    //TODO:: Relaoad data
    NSLog(@"Total Results: %@", results);
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    results = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict
{
    //initialize the Person Element.
    record = [[Person alloc] init];
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName
{
    
	if([elementName isEqualToString:@"person"]) {
		[results addObject:record];
		
				
	//	[record release];
		record = nil;
	}
	
	
	else 
    {
        if ([record respondsToSelector: @selector(elementName)]) {
            [record setValue:currentElementValue forKey:elementName];
        }
       
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if ( [string isEqualToString:@"\n"])
	{
		string = @"";
	}
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
    
#if kNSLog
	NSLog(@"Processing Value: %@", currentElementValue);
#endif
	
}

@end

