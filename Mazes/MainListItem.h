//
//  MainListItem.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainListItem : NSObject

@property (assign, nonatomic) int mazeId;
@property (strong, nonatomic) NSString *mazeName;
@property (assign, nonatomic) float averageRating;
@property (assign, nonatomic) int ratingsCount;
@property (assign, nonatomic) BOOL userStarted;
@property (assign, nonatomic) float userRating;
@property (strong, nonatomic) NSDate *lastModified;

@end
