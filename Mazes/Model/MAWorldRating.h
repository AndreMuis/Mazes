//
//  MAWorldRating.h
//  Mazes
//
//  Created by Andre Muis on 7/3/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAWorldRating : NSObject

@property (readonly, strong, nonatomic) NSString *userRecordName;
@property (readonly, assign, nonatomic) float value;

+ (instancetype)worldRatingWithUserRecodName: (NSString *)userRecordName
                                       value: (float)value;

- (void)updateWithValue: (float)value;

@end
