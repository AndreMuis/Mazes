//
//  MAEvent.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAEvent.h"

#import "MAConstants.h"
#import "MAUtilities.h"

@implementation MAEvent

- (id)initWithTarget: (id)target action: (SEL)action intervalSecs: (int)intervalSecs repeats: (BOOL)repeats
{
    self = [super init];
    
    if (self) 
    {
        _target = target;
        _action = action;
        _object = nil;
        _intervalSecs = intervalSecs;
        _repeats = repeats;
        
        _elapsedSecs = 0.0;
    }
    
    return self;
}

- (id)initWithTarget: (id)target action: (SEL)action object: (id)object intervalSecs: (int)intervalSecs repeats: (BOOL)repeats;
{
    self = [super init];
    
    if (self)
    {
        _target = target;
        _action = action;
        _object = object;
        _intervalSecs = intervalSecs;
        _repeats = repeats;
        
        _elapsedSecs = 0.0;
    }
    
    return self;

}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];

    desc = [desc stringByAppendingFormat: @"target = %@; ", self.target];
    desc = [desc stringByAppendingFormat: @"action = %@; ", NSStringFromSelector(self.action)];
    desc = [desc stringByAppendingFormat: @"intervalSecs = %f; ", self.intervalSecs];
    desc = [desc stringByAppendingFormat: @"repeats = %d; ", self.repeats];
    
    desc = [desc stringByAppendingFormat: @"elapsedSecs = %f>", self.elapsedSecs];
    
    return desc;
}

@end




















