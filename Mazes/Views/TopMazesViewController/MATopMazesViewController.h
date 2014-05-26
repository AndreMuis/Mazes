//
//  MATopMazesViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Reachability/Reachability.h>

#import "MATopMazeTableViewCell.h"

@class MACreateViewController;
@class MADesignViewController;
@class MAGameViewController;
@class MAMainViewController;
@class MAMazeManager;
@class MASoundManager;
@class MATextureManager;
@class MAWebServices;

@interface MATopMazesViewController : UIViewController

@property (readwrite, strong, nonatomic) MACreateViewController *createViewController;
@property (readwrite, strong, nonatomic) MADesignViewController *designViewController;
@property (readwrite, strong, nonatomic) MAGameViewController *gameViewController;
@property (readwrite, strong, nonatomic) MAMainViewController *mainViewController;

- (id)initWithReachability: (Reachability *)reachability
               webServices: (MAWebServices *)webServices
               mazeManager: (MAMazeManager *)mazeManager
            textureManager: (MATextureManager *)textureManager
              soundManager: (MASoundManager *)soundManager;

@end
