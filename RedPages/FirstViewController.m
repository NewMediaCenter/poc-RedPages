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
    [searchActive startAnimating];
    [self.searchDisplayController setActive:NO animated:YES];
    
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    //add incoming data to NSMutableData dataarray.
    NSLog(@"Recieved Data!");
    [rawResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
//    NSLog(@"Raw Data: %@", rawResponse);
    
    // lets create it and give it some data
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:rawResponse];
    // we want the messages
    [parser setDelegate:self];
    //lets have it start parsing
    [parser parse];
    
   
    
    
    //now that its done, we can release it
    //[parser release]; ~~ DEPRECATED WITH ARC
    
    //TODO:: Relaoad data
   // NSLog(@"Total Results: %@", results);
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
     [searchActive stopAnimating];
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
            NSLog (@"Person: %@", record);
            [results addObject:record]; 
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
            ABRecordRef newContact = ABPersonCreate();
            CFErrorRef *anError = NULL;
    ABRecordSetValue(newContact, kABPersonFirstNameProperty,(__bridge_retained CFStringRef) [luckyGuy givenName], anError);
    ABRecordSetValue(newContact, kABPersonLastNameProperty,(__bridge_retained CFStringRef) [luckyGuy sn], anError);
    NSString *trimmedString = [[luckyGuy telephoneNumber] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    ABRecordSetValue(newContact, kABPersonPhoneMainLabel,(__bridge_retained CFNumberRef) [trimmedString integerValue], anError);
    ABRecordSetValue(newContact, kABPersonJobTitleProperty,(__bridge_retained CFStringRef) [luckyGuy title], anError);
    ABRecordSetValue(newContact, kABPersonEmailProperty,(__bridge_retained CFStringRef) [luckyGuy mail], anError);
    ABRecordSetValue(newContact, kABPersonDepartmentProperty,(__bridge_retained CFStringRef) [luckyGuy unlHRPrimaryDepartment], anError);
        
    NSData *data=UIImageJPEGRepresentation([luckyGuy image], 1.0);
    CFDataRef dr = CFDataCreate(NULL, [data bytes], [data length]);
    
    if ( data != nil){
        ABPersonSetImageData(newContact, dr, anError);
    }
    
			ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = newContact;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = YES;
    picker.alternateName = [luckyGuy displayName];
    picker.title = [luckyGuy displayName];
    picker.message = [luckyGuy title];
            
			
			[self.navigationController pushViewController:picker animated:YES];
}

@end

