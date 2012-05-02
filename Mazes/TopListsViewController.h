//
//  TopListsViewController.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Communication.h"
#import "Colors.h"
#import "GameViewController.h"
#import "TopListsTableViewCell.h"

@interface TopListsViewController : UIViewController <UITableViewDelegate, ADBannerViewDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>
{
	Communication *comm;
		
	NSMutableArray *array;
	
	int selectedSegmentIndex;

	UIImageView *imageViewHighestRated, *imageViewNewest, *imageViewYours;
	UIImageView *imageViewMazes, *imageViewCreate;
	
	UITableView *TableView;
	TopListsTableViewCell *TableViewCell;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageViewHighestRated;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewNewest;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewYours;

@property (nonatomic, retain) IBOutlet UITableView *TableView;
@property (nonatomic, retain) IBOutlet TopListsTableViewCell *TableViewCell;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewMazes;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewCreate;

- (void)loadMazeList;
- (void)loadMazeListResponse;

- (IBAction)btnHighestRatedTouchDown: (id)sender;
- (IBAction)btnNewestTouchDown: (id)sender;
- (IBAction)btnYoursTouchDown: (id)sender;

- (void)setupSegmentsWithSelectedIndex: (int)index;

- (IBAction)btnCreateTouchDown: (id)sender;

@end
