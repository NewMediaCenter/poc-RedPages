//
//  FirstViewController.h
//  RedPages
//
//  Created by Jerrad Thramer on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Person.h"

@interface FirstViewController : UIViewController < ABPeoplePickerNavigationControllerDelegate,
ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate,
ABUnknownPersonViewControllerDelegate, NSXMLParserDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *results;
    NSMutableData *rawResponse;
    NSURLConnection *directoryConnection;
    UIActivityIndicatorView *activityIndicator;
    UIBarButtonItem *barButton;
    Person *record;
    NSMutableString *currentElementValue;
    IBOutlet UITableView *tableView;
    IBOutlet ABUnknownPersonViewController *addressbookView;

}

@property (nonatomic, retain) NSURLConnection *directoryConnnection;
@property (nonatomic, retain) NSMutableData *rawResponse;
@property (nonatomic, retain) NSMutableString *currentElementValue;
@property (nonatomic, retain) Person *record;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)showUnknownPersonViewController;
- (void)letsParse;

@end
