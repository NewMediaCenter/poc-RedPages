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

@interface QuickContactsViewController : UITableViewController <   ABPeoplePickerNavigationControllerDelegate,
ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate,
ABUnknownPersonViewControllerDelegate, NSXMLParserDelegate>

{
    NSMutableArray *results;
    NSMutableData *rawResponse;
    NSString *query;
    NSString *selectedCN;
    BOOL searchActive;
    

}


@end
