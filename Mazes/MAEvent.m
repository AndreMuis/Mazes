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
    NSString *desc = [NSString stringWithFormat: @"target = %@\n", self.target];
    desc = [NSString stringWithFormat: @"%@action = %@\n", desc, NSStringFromSelector(self.action)];
    desc = [NSString stringWithFormat: @"%@intervalSecs = %f\n", desc, self.intervalSecs];
    desc = [NSString stringWithFormat: @"%@repeats = %d\n", desc, self.repeats];
    
    desc = [NSString stringWithFormat: @"%@elapsedSecs = %f\n", desc, self.elapsedSecs];
    
    return desc;
}

@end
