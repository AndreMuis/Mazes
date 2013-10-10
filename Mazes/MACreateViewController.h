//
//  MACreateViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAViewController.h"

@class MAConstants;
@class MAEditViewController;
@class MAMainViewController;
@class MAMazeManager;
@class MAMaze;
@class MAStyles;
@class MATextureManager;
@class MATopMazesViewController;

@interface MACreateViewController : MAViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (readwrite, strong, nonatomic) MAMaze *maze;

@property (readwrite, strong, nonatomic) MAEditViewController *editViewController;
@property (readwrite, strong, nonatomic) MAMainViewController *mainViewController;
@property (readwrite, strong, nonatomic) MATopMazesViewController *topMazesViewController;

- (id)initWithConstants: (MAConstants *)constants
            mazeManager: (MAMazeManager *)mazeManager
         textureManager: (MATextureManager *)textureManager
                 styles: (MAStyles *)styles;

@end
