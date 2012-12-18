//
//  Globals.h
//  iPad_Mazes
//
//  Created by Andre Muis on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class DataAccess;
@class Maze;
@class GameViewController;
@class CreateViewController;
@class EditViewController;
@class Sounds;
@class Textures;

@interface Globals : NSObject 

@property (nonatomic, retain) AppDelegate *appDelegate;

@property (nonatomic, retain) Maze *mazeMain;
@property (nonatomic, retain) Maze *mazeEdit;

@property (nonatomic, retain) GameViewController *gameViewController;

@property (nonatomic, retain) CreateViewController *createViewController;
@property (nonatomic, retain) EditViewController *editViewController;

@property (nonatomic, retain) UIView *activityView;

+ (Globals *)shared;

@end
