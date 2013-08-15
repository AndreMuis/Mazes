//
//  MAUser.h
//  Mazes
//
//  Created by Andre Muis on 12/15/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface MAUser : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@end
