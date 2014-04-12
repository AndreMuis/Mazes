//
//  MASoundManager.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MASoundManager.h"

#import "MAGameViewController.h"
#import "MASound.h"
#import "MAUtilities.h"

@interface MASoundManager ()

@property (strong, nonatomic, readonly) NSArray *sounds;

@end

@implementation MASoundManager

- (id)initWithSounds: (NSArray *)sounds
{
    self = [super init];
	
	if (self)
	{
        _sounds = sounds;
	}
	
    return self;
}

- (int)count
{
    return self.sounds.count;
}

- (NSArray *)sortedByName
{
    NSArray *sortedArray = [self.sounds sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2)
    {
        NSString *name1 = ((MASound *)obj1).name;
        NSString *name2 = ((MASound *)obj2).name;
        
        return [name1 compare: name2];
    }];
    
    return sortedArray;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"sounds = %@>", self.sounds];

    return desc;
}

@end























