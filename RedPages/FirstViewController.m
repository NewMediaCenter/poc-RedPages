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
    NSString *searchQueryURL = [NSString stringWithFormat:
                              @"http://peoplefinder.unl.edu/service.php?q=%@&format=xml",[[searchBar text] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *queryRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchQueryURL]];
    [self setDirectoryConnnection:[[NSURLConnection alloc] initWithRequest:queryRequest delegate:self]];
    if (self.directoryConnnection == nil)
    {
        // do stuff
    }
    [searchActive startAnimating];
    
    
    
}

@end
