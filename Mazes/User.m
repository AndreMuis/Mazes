//
//  User.m
//  Mazes
//
//  Created by Andre Muis on 12/15/12.
//
//

#import "User.h"

@implementation User

- (id)init
{
    self = [super init];
	
    if (self)
	{
        _id = 0;
        _uuid = nil;
	}
	
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"id = %d", self.id];
    desc = [NSString stringWithFormat: @"%@, uuid = %@", desc, self.uuid];
    
    return desc;
}

@end
