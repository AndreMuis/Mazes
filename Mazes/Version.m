//
//  Version.m
//  Mazes
//
//  Created by Andre Muis on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Version.h"

@implementation Version

@synthesize number;

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"number = %f", self.number];
    
    return desc;
}

@end
