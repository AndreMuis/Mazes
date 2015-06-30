//
//  MAStarViewDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAStarView;

@protocol MAStarViewDelegate <NSObject>

@required

- (void)starViewDidTap: (MAStarView *)starView;

@end
