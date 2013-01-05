//
//  MainListViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAViewController.h"
#import "ServerOperations.h"

@class MainListTableViewCell;
@class MAEvent;

@interface MainListViewController : MAViewController <
    UITableViewDataSource,
    UITableViewDelegate,
    MAServerOperationsHighestRatedListDelegate,
    MAServerOperationsNewestListDelegate,
    MAServerOperationsYoursListDelegate>
{
    NSOperationQueue *operationQueue;;
    
    MAEvent *setupOperationQueueEvent;
    
    NSArray *highestRatedMainListItems;
    BOOL highestRatedListHasLoaded;
    
    NSArray *newestMainListItems;
    BOOL newestMainListHasLoaded;
    
    NSArray *yoursMainListItems;
    BOOL yoursMainListHasLoaded;
    
    int selectedSegmentIndex;
    
    BOOL viewAppearingFirstTime;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHighestRated;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNewest;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewYours;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MainListTableViewCell *tableViewCell;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMazes;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCreate;

+ (MainListViewController *)shared;

- (IBAction)btnHighestRatedTouchDown: (id)sender;
- (IBAction)btnNewestTouchDown: (id)sender;
- (IBAction)btnYoursTouchDown: (id)sender;

- (void)refreshSegments;

- (void)setupOperationQueue;

- (NSArray *)currentMainListItems;

- (IBAction)btnCreateTouchDown: (id)sender;

@end
