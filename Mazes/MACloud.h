//
//  MACloud.h
//  Mazes
//
//  Created by Andre Muis on 1/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MACloud : NSObject

@property (readonly, assign, nonatomic) BOOL isAvailable;

@property (readwrite, strong, nonatomic) NSString *username;
@property (readwrite, strong, nonatomic) NSString *password;

- (void)clear;

@end
