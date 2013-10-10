//
//  MALatestVersion.h
//  Mazes
//
//  Created by Andre Muis on 4/30/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MALatestVersion : NSObject

@property (readonly, strong, nonatomic) NSString *latestVersionId;
@property (readonly, assign, nonatomic) float latestVersion;

@end
