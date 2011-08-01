//
//  Person.m
//  RedPages
//
//  Created by Jerrad Thramer on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize displayName;
@synthesize sn;
@synthesize mail;
@synthesize title;
@synthesize imageURL;
@synthesize givenName;
@synthesize postalAddress;
@synthesize telephoneNumber;
@synthesize unlHRPrimaryDepartment;
@synthesize cn;
@synthesize ou;
@synthesize image;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)description
{
    NSString *returnString = [[NSString alloc] initWithFormat:@"Person:@%",displayName];
    return returnString;
}

@end
