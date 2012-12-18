//
//  MainListViewController.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebServices.h"

@class MainListTableViewCell;

@interface MainListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MAWebServicesGetHighestRatedDelegate>
{
	NSMutableArray *array;
	
	int selectedSegmentIndex;
    
    WebServices *highestRatedWebServices;
    NSArray *highestRatedMazeListItems;
    
    WebServices *newestWebServices;
    NSArray *newestMazeListItems;

    WebServices *yoursRatedWebServices;
    NSArray *yoursMazeListItems;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageViewHighestRated;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewNewest;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewYours;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet MainListTableViewCell *tableViewCell;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewMazes;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewCreate;

+ (MainListViewController *)shared;

- (void)getHighestRatedList;

- (void)loadMazeList;
- (void)loadMazeListResponse;

- (IBAction)btnHighestRatedTouchDown: (id)sender;
- (IBAction)btnNewestTouchDown: (id)sender;
- (IBAction)btnYoursTouchDown: (id)sender;

- (void)setupSegmentsWithSelectedIndex: (int)index;

- (IBAction)btnCreateTouchDown: (id)sender;

@end
