//
//  Person.h
//  RedPages
//
//  Created by Jerrad Thramer on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface Person : NSObject
{
    NSString *givenName;
    NSString *sn;
    NSString *displayName;
    NSString *mail;
    NSNumber *telephoneNumber;
    NSString *title;
    NSString *unlHRPrimaryDepartment;
    NSString *postalAddress;
    NSURL *imageURL;
}

@property (nonatomic, retain) NSString *givenName;
@property (nonatomic, retain) NSString *sn;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *mail;
@property (nonatomic, retain) NSNumber *telephoneNumber;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *unlHRPrimaryDepartment;
@property (nonatomic, retain) NSString *postalAddress;
@property (nonatomic, retain) NSURL *imageURL;

    @end
