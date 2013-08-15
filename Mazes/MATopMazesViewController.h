//
//  MATopMazesViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAViewController.h"

@class MAEvent;
@class MATopMazesTableViewCell;

@interface MATopMazesViewController : MAViewController <
    UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *highestRatedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newestImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yoursImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *createImageView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

+ (MATopMazesViewController *)shared;

- (IBAction)highestRatedButtonTouchDown: (id)sender;
- (IBAction)newestButtonTouchDown: (id)sender;
- (IBAction)yoursButtonTouchDown: (id)sender;

- (void)refreshCurrentMazes;

@end
