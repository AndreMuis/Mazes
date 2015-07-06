//
//  MADesignViewDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MADesignView;
@class MAWallNode;

@protocol MADesignViewDelegate <NSObject>

@required

- (void)designView: (MADesignView *)designView
    didTapWallNode: (MAWallNode *)wallNode;

@end
