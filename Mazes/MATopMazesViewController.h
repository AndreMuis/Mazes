//
//  MATopMazesViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMFatFractal/AMFatFractal.h>

#import "MAViewController.h"

@class MAConstants;
@class MACreateViewController;
@class MAEditViewController;
@class MAGameViewController;
@class MAMainViewController;
@class MAMazeManager;
@class MASoundManager;
@class MAStyles;
@class MATextureManager;
@class MATopMazesTableViewCell;

@interface MATopMazesViewController : MAViewController

@property (readwrite, strong, nonatomic) FFUser *currentUser;

@property (readwrite, strong, nonatomic) MACreateViewController *createViewController;
@property (readwrite, strong, nonatomic) MAEditViewController *editViewController;
@property (readwrite, strong, nonatomic) MAGameViewController *gameViewController;
@property (readwrite, strong, nonatomic) MAMainViewController *mainViewController;

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal
                 constants: (MAConstants *)constants
               mazeManager: (MAMazeManager *)mazeManager
            textureManager: (MATextureManager *)textureManager
              soundManager: (MASoundManager *)soundManager
                    styles: (MAStyles *)styles
                bannerView: (ADBannerView *)bannerView;

- (void)downloadTopMazeItems;

@end
