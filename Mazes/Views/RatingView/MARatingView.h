//
//  MARatingView.h
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MARatingViewDelegate.h"

typedef enum : int
{
    MARatingViewUnknown = 0,
    MARatingViewDisplayOnly = 1,
    MARatingViewEditable = 2,
    MARatingViewSelectable = 3
} MARatingViewType;

@interface MARatingView : UIView <MARatingViewDelegate, UIPopoverControllerDelegate>

- (void)setupWithDelegate: (id<MARatingViewDelegate>)aDelegate
                   rating: (float)aRating
                     type: (MARatingViewType)aType
                starColor: (UIColor *)aStarColor;

@end
