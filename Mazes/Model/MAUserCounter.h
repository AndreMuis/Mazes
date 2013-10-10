//
//  MAUserCounter.h
//  Mazes
//
//  Created by Andre Muis on 9/16/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAUserCounter : NSObject

@property (readonly, strong, nonatomic) NSString *userCounterId;
@property (readonly, assign, nonatomic) NSUInteger count;

@end
