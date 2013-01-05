//
//  User.h
//  Mazes
//
//  Created by Andre Muis on 12/15/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *udid;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

@end
