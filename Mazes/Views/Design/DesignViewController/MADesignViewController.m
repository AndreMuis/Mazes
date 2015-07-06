//
//  MADesignViewController.m
//  Mazes
//
//  Created by Andre Muis on 6/25/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MADesignViewController.h"

#import "MAConstants.h"
#import "MACurrentUser.h"
#import "MADesignView.h"
#import "MADesignViewDelegate.h"
#import "MAWall.h"
#import "MAWallNode.h"
#import "MAWorldManager.h"
#import "MAWorld.h"

@interface MADesignViewController () <MADesignViewDelegate>

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
    
    MADesignView *view = (MADesignView *)self.view;
    
    [view drawAxes];
    
    [self.worldManager getWorldsWithCompletionHandler: ^(NSError *error)
    {
        if (error == nil)
        {
            if (self.worldManager.worldsCount == 0)
            {
                MAWorld *world = [MAWorld worldWithUserRecordName: [MACurrentUser shared].recordname
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
                _world = [self.worldManager worldAtIndex: 0];
            
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

- (void)designView: (MADesignView *)designView
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
    
    MADesignView *view = (MADesignView *)self.view;
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
            
            MADesignView *view = (MADesignView *)self.view;
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
























