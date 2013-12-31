//
//  MAEvents.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAEvent;

@interface MAEvents : NSObject

- (void)addEvent: (MAEvent *)event;
- (BOOL)hasEvent: (MAEvent *)event;

- (void)removeEvent: (MAEvent *)gameEvent;
- (void)removeEventsWithTarget: (id)target;

@end
