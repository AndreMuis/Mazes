//
//  MACreateViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MADesignViewController;
@class MAMainViewController;
@class MAMazeManager;
@class MAMaze;
@class MATextureManager;
@class MATopMazesViewController;

@interface MACreateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (readwrite, strong, nonatomic) MAMaze *maze;

@property (readwrite, strong, nonatomic) MADesignViewController *designViewController;
@property (readwrite, strong, nonatomic) MAMainViewController *mainViewController;
@property (readwrite, strong, nonatomic) MATopMazesViewController *topMazesViewController;

- (id)initWithMazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager;

@end
