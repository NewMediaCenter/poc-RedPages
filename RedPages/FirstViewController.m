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
@synthesize currentElementValue;
@synthesize record;

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
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    self.searchDisplayController.searchBar.scopeButtonTitles = nil;
    activityIndicator = 
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
     barButton = 
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    // Set to Left or Right
    [[self navigationItem] setRightBarButtonItem:barButton];
    

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

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:@"UITableViewCell"];
    }
    
    // Set the text on the cell with the description of the possession
    // that is at the nth index of possessions, where n = row this cell
    // will appear in on the tableview
    Person *p = [results objectAtIndex:[indexPath row]];
    

    [[cell textLabel] setText:[p displayName]];
    [[cell detailTextLabel] setText:[p title]];
    [[cell imageView] setImage:[p image]];
    
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"THIS WORKS");
    rawResponse = [[NSMutableData alloc] init];
    NSString *searchQueryURL = [NSString stringWithFormat:
                              @"http://directory.unl.edu/service.php?q=%@&format=xml",[[searchBar text] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *queryRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchQueryURL]]; 
    NSLog (@"Loading URL: %@", searchQueryURL);
    [self setDirectoryConnnection:[[NSURLConnection alloc] initWithRequest:queryRequest delegate:self startImmediately:YES]];
    if (self.directoryConnnection == nil)
    {
        // do stuff
    }
    
    [activityIndicator startAnimating];
    [self.searchDisplayController setActive:NO animated:YES];
    
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    //add incoming data to NSMutableData dataarray.
   // NSLog(@"Recieved Data!");
    [rawResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
//    NSLog(@"Raw Data: %@", rawResponse);
    
    // lets create it and give it some data
    
    // we want the messages
    
    //lets have it start parsing
    //[parser parse];
    // ACTUALLY, lets have it parse in an operation
  
    [self letsParse];
 
    
    
    //now that its done, we can release it
    //[parser release]; ~~ DEPRECATED WITH ARC
    
    //TODO:: Relaoad data
   // NSLog(@"Total Results: %@", results);
    
}
- (void)letsParse
{
    @autoreleasepool {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:rawResponse];
        [parser setDelegate:self];
        [NSThread detachNewThreadSelector:@selector(parse) toTarget:parser withObject:nil];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
     [activityIndicator stopAnimating];
    [tableView reloadData];
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
    if([elementName isEqualToString:@"person"]){
    record = [[Person alloc] init];
    }
    
    currentElementValue = nil;
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName
{
    
	if([elementName isEqualToString:@"person"]) {
        if( [[record displayName] length] > 0 ){
            [record setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[record imageURL]]]];
    //        NSLog (@"Person: %@", record);
            [results addObject:record]; 
            [tableView reloadData];
        }
		
		
				
	
	}
	else if ([elementName isEqualToString:@"cn"]) {
		[[record cn] addObject:currentElementValue];
	}
	
	else if ([elementName isEqualToString:@"ou"]) {
		[[record ou] addObject:currentElementValue];
	}
    
    else if ([elementName isEqualToString:@"givenName"]) {
		[record setGivenName:currentElementValue];
	}
	
	else if ([elementName isEqualToString:@"displayName"]) {
        [record setDisplayName:currentElementValue];
    }
    else if ([elementName isEqualToString:@"mail"]) {
		[record setMail:currentElementValue];
	}
	else if ([elementName isEqualToString:@"sn"]) {
		[record setSn:currentElementValue];
	}
	else if ([elementName isEqualToString:@"telephoneNumber"]) {
		[record setTelephoneNumber:currentElementValue];
	}
    else if ([elementName isEqualToString:@"title"]) {
		[record setTitle:currentElementValue];
	}
	
	else if ([elementName isEqualToString:@"unlHRPrimaryDepartment"]) {
		[record setUnlHRPrimaryDepartment:currentElementValue];
	}
    else if ([elementName isEqualToString:@"postalAddress"]) {
		[record setPostalAddress:currentElementValue];
	}
	
	else if ([elementName isEqualToString:@"imageURL"]) {
		[record setImageURL: [NSURL URLWithString:currentElementValue]];
	}
   
    //NSLog(@"element name = %@ | %@",elementNacme, currentElementValue);	
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
    

//	NSLog(@"Processing Value: %@", currentElementValue);

  
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *luckyGuy = [results objectAtIndex:indexPath.row];
            ABRecordRef newPerson = ABPersonCreate();
            CFErrorRef *anError = NULL;
    
    
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge_retained CFStringRef)[luckyGuy givenName], anError);
	ABRecordSetValue(newPerson, kABPersonLastNameProperty,(__bridge_retained CFStringRef) [luckyGuy sn], anError);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty,(__bridge_retained CFStringRef) [luckyGuy title], anError);
    ABRecordSetValue(newPerson, kABPersonDepartmentProperty,(__bridge_retained CFStringRef) [luckyGuy unlHRPrimaryDepartment], anError);
    //ABRecordSetValue(newPerson, kABPersonAddressProperty,(__bridge_retained CFStringRef) [luckyGuy postalAddress], anError);
    NSData *data=UIImageJPEGRepresentation([luckyGuy image], 1.0);
    CFDataRef dr = CFDataCreate(NULL, [data bytes], [data length]);
    
    if ( data != nil){
        ABPersonSetImageData(newPerson, dr, anError);
    }
    ABMultiValueRef phone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSString *trimmedString = [[luckyGuy telephoneNumber] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
     ABMultiValueAddValueAndLabel(phone, (__bridge_retained CFStringRef)trimmedString, kABPersonPhoneMainLabel,NULL);
    
    ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	 bool didAdd = ABMultiValueAddValueAndLabel(email, (__bridge_retained CFStringRef) [luckyGuy mail], kABWorkLabel, NULL);
	
	if (didAdd == YES)
	{
		ABRecordSetValue(newPerson, kABPersonEmailProperty, email, anError);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, phone, anError);
       
		if (anError == NULL)
		{
			ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = newPerson;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = YES;
			picker.alternateName = [luckyGuy displayName];
			picker.title = [luckyGuy displayName];
			picker.message = @"University of Nebraska-Lincoln";
			
			[self.navigationController pushViewController:picker animated:YES];
        }
    }

			
}


@end

