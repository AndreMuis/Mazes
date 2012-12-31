//
//  Globals.h
//  Mazes
//
//  Created by Andre Muis on 1/13/11.
//  Copyright 2011 Andre Muis. All rights reserved.
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

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) CreateViewController *createViewController;
@property (strong, nonatomic) EditViewController *editViewController;

@property (strong, nonatomic) UIView *activityView;

+ (Globals *)shared;

@end
