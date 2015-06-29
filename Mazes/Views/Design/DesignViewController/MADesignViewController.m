//
//  MADesignViewController.m
//  Mazes
//
//  Created by Andre Muis on 6/25/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MADesignViewController.h"

#import "MAConstants.h"
#import "MASceneView.h"
#import "MASceneViewDelegate.h"
#import "MAWall.h"
#import "MAWallNode.h"
#import "MAWorldManager.h"
#import "MAWorld.h"

@interface MADesignViewController () <MASceneViewDelegate>

@property (readonly, strong, nonatomic) MAWorldManager *worldManager;
@property (readonly, strong, nonatomic) MAWorld *world;

@end

@implementation MADesignViewController

- (instancetype)initWithCoder: (NSCoder *)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _worldManager = [MAWorldManager worldManager];
        _world = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MASceneView *view = (MASceneView *)self.view;
    
    [view drawAxes];
    
    [self.worldManager getWorldsWithCompletionHandler: ^(NSArray *worlds, NSError *error)
    {
        if (error == nil)
        {
            if (worlds.count == 0)
            {
                MAWorld *world = [MAWorld worldWithUserId: @""
                                                     name: @"Andre's World"
                                                     rows: 5
                                                  columns: 5
                                                 isPublic: NO];
                
                [self.worldManager saveWithWorld: world
                               completionHandler: ^(MAWorld *world, NSError *error)
                {
                    _world = world;

                    if (error == nil)
                    {
                        [view setupWithDelegate: self];
                        [view refreshWithWorld: self.world];
                    }
                    else
                    {
                        NSLog(@"%@", error);
                    }
                }];
            }
            else
            {
                _world = worlds.lastObject;
            
                [view setupWithDelegate: self];
                [view refreshWithWorld: self.world];
            }
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

- (void)sceneView: (MASceneView *)sceneView
   didTapWallNode: (MAWallNode *)wallNode
{
    MAWall *wall = [self.world wallWithRow: wallNode.row
                                    column: wallNode.column
                                  position: wallNode.wallPosition];
    
    if (wall == nil)
    {
        MAWall *wall = [MAWall wallWithRow: wallNode.row
                                    column: wallNode.column
                                  position: wallNode.wallPosition];
        
        [self.world addWall: wall];
    }
    else
    {
        [self.world removeWall: wall];
    }
    
    MASceneView *view = (MASceneView *)self.view;
    [view refreshWithWorld: self.world];
}

- (IBAction)saveButtonTapped: (id)sender
{
    [self.worldManager saveWithWorld: self.world
                   completionHandler: ^(MAWorld *world, NSError *error)
    {
        if (error == nil)
        {
            _world = world;
            
            MASceneView *view = (MASceneView *)self.view;
            [view refreshWithWorld: self.world];
            
            NSLog(@"saved");
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

@end
























