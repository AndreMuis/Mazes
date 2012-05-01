//
//  TopListsItem.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopListsItem : NSObject

@property (assign, nonatomic) int mazeId;
@property (retain, nonatomic) NSString *mazeName;
@property (assign, nonatomic) int usersFinished;
@property (assign, nonatomic) BOOL started;
@property (assign, nonatomic) BOOL finished;
@property (assign, nonatomic) float avgRating;
@property (assign, nonatomic) int numRatings;
@property (assign, nonatomic) float userRating;
@property (retain, nonatomic) NSString *dateLastMod;

@end
