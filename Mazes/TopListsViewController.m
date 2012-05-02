//
//  MazeListViewController.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TopListsViewController.h"

@implementation TopListsViewController

@synthesize imageViewHighestRated,  imageViewNewest, imageViewYours, TableView, TableViewCell, imageViewMazes, imageViewCreate;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	array = [[NSMutableArray alloc] init];

	TableView.backgroundColor = [Styles instance].mazeList.tableBackgroundColor;
	
	NSNumber *free = (NSNumber *)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"Free"];
	if ([free boolValue] == NO)
	{
		TableView.frame = CGRectMake(TableView.frame.origin.x, TableView.frame.origin.y, TableView.frame.size.width, TableView.frame.size.height + [Styles instance].bannerView.height);
	}
		
	selectedSegmentIndex = 0;
	[self setupSegmentsWithSelectedIndex: 1];
	
	TopListsItem *topListsItem = [[TopListsItem alloc] init];
	topListsItem.MazeId = 0;
	[Globals instance].gameViewController.topListsItem = topListsItem;
}	

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
		
	NSNumber *free = (NSNumber *)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"Free"];
	if ([free boolValue] == YES)
	{
		ADBannerView *banner = [Globals instance].bannerView;
		
		banner.delegate = self;
		banner.frame = CGRectMake(banner.frame.origin.x, TableView.frame.origin.y + TableView.frame.size.height, banner.frame.size.width, banner.frame.size.height);
		
		[self.view addSubview: banner];
	}
}

- (void)viewDidAppear: (BOOL)animated
{
	[super viewDidAppear: animated];

	if ([Globals instance].gameViewController.topListsItem.mazeId != 0)
	{
        TopListsItem *topListsItem = [[TopListsItem alloc] init];
		topListsItem.MazeId = 0;
		[Globals instance].gameViewController.topListsItem = topListsItem;
		
		[[Globals instance].gameViewController.mapView clearMap];
		
		[[Globals instance].gameViewController clearMessage];
				
		[[Globals instance].gameViewController.mazeView clearMaze];
	}
}

// Segmented Control

- (IBAction)btnHighestRatedTouchDown: (id)sender
{	
	if (selectedSegmentIndex != 1)
	{
		[self setupSegmentsWithSelectedIndex: 1];
	
		[self loadMazeList];	
	}
}

- (IBAction)btnNewestTouchDown: (id)sender
{
	if (selectedSegmentIndex != 2)
	{
		[self setupSegmentsWithSelectedIndex: 2];
	
		[self loadMazeList];	
	}
}

- (IBAction)btnYoursTouchDown: (id)sender
{
	if (selectedSegmentIndex != 3)
	{
		[self setupSegmentsWithSelectedIndex: 3];
	
		[self loadMazeList];	
	}
}

- (void)setupSegmentsWithSelectedIndex: (int)index
{
	selectedSegmentIndex = index;
	
	if (selectedSegmentIndex == 1)
    {
		imageViewHighestRated.image = [UIImage imageNamed: @"btnHighestRatedOrange.png"];
    }
	else
    {
		imageViewHighestRated.image = [UIImage imageNamed: @"btnHighestRatedBlue.png"];
    }
		
	if (selectedSegmentIndex == 2)
    {
		imageViewNewest.image = [UIImage imageNamed: @"btnNewestOrange.png"];
    }
	else
    {
		imageViewNewest.image = [UIImage imageNamed: @"btnNewestBlue.png"];
    }

	if (selectedSegmentIndex == 3)
    {
		imageViewYours.image = [UIImage imageNamed: @"btnYoursOrange.png"];
    }
	else
    {
		imageViewYours.image = [UIImage imageNamed: @"btnYoursBlue.png"];
    }
}

// Tab Bar

- (IBAction)btnCreateTouchDown: (id)sender
{
	[self.navigationController pushViewController:(UIViewController *)[Globals instance].editViewController animated: NO];
}

// Maze Lists

- (void)loadMazeList
{
	if (selectedSegmentIndex == 1)
	{
		comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeListResponse) Action: @"GetMazeHighestRated" WaitMessage: @"Loading"];
		
		[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
		
		[comm post];
	}
	else if (selectedSegmentIndex == 2)
	{
		comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeListResponse) Action: @"GetMazeNewest" WaitMessage: @"Loading"];
		
		[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
		
		[comm post];
	}
	else if (selectedSegmentIndex == 3)
	{
		comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeListResponse) Action: @"GetMazeYours" WaitMessage: @"Loading"];
		
		[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
		
		[comm post];
	}
}	

- (void)loadMazeListResponse
{
	[array removeAllObjects];
	
	if (comm.errorOccurred == NO)
	{
		if ([XML isDocEmpty: comm.responseDoc] == NO)
		{
			xmlNodePtr node = [XML getNodesFromDoc: comm.responseDoc XPath: "/Response/Mazes/Maze"];
			
			xmlNodePtr nodeCurr;
			for (nodeCurr = node; nodeCurr; nodeCurr = nodeCurr->next)
			{
				TopListsItem *topListsItem = [[TopListsItem alloc] init];
				
				topListsItem.MazeId = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "MazeId"] intValue];
				topListsItem.MazeName = [XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "Name"];					
				topListsItem.UsersFinished = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "UsersFinished"] intValue];
				topListsItem.Started = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "Started"] isEqualToString: @"True"] ? YES : NO;
				topListsItem.Finished = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "Finished"] isEqualToString: @"True"] ? YES : NO;
				topListsItem.AvgRating = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "AvgRating"] floatValue];
				topListsItem.NumRatings = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "NumRatings"] intValue];
				topListsItem.UserRating = [[XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "UserRating"] floatValue];
				topListsItem.DateLastMod = [XML getNodeValueFromDoc: comm.responseDoc Node: nodeCurr XPath: "DateLastMod"];
				
				[array addObject: topListsItem];
			}
			
			xmlFreeNodeList(node);
		}
	}
		
	[TableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section 
{
	NSInteger rows = 0;
	
	if (array.count % 2 == 0)
    {
		rows = array.count / 2;
    }
	else if (array.count % 2 == 1)
    {
		rows = (array.count + 1)/ 2;
    }
	
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"TopListsTableViewCell";
    
    TopListsTableViewCell *cell = (TopListsTableViewCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed: @"TopListsTableViewCell" owner: self options: nil];
		cell = TableViewCell;
		
		TableViewCell = nil;
    }
    
	if (array.count > 0)
	{	
		int i = indexPath.row * 2;

		TopListsItem *topListsItem = [array objectAtIndex: i];
		
		cell.viewRatingUser1.mazeId = topListsItem.mazeId;
		
		cell.nameLabel1.textColor = [Styles instance].mazeList.textColor;
		cell.nameLabel1.text = topListsItem.mazeName;
		
		cell.dateLabel1.textColor = [Styles instance].mazeList.textColor;
		cell.dateLabel1.text = topListsItem.dateLastMod;
		
		cell.viewRatingAvg1.backgroundColor = [Colors instance].transparentColor;
		cell.lblNumRatings1.textColor = [Styles instance].mazeList.textColor;
		if (topListsItem.avgRating == 0.0)
		{
			cell.viewRatingAvg1.Mode = [Constants instance].RatingMode.DoNothing;

			cell.lblNumRatings1.text = @"";
		}
		else 
		{
			cell.viewRatingAvg1.Mode = [Constants instance].RatingMode.DisplayAvg;
			cell.viewRatingAvg1.rating = topListsItem.avgRating;
			
			cell.lblNumRatings1.text = [NSString stringWithFormat: @"%d ratings", topListsItem.numRatings];
		}
		
		cell.viewRatingUser1.backgroundColor = [Colors instance].transparentColor;
		if (topListsItem.started == NO)
		{
			cell.viewRatingUser1.Mode = [Constants instance].RatingMode.DoNothing;
		}
		else
		{
			cell.viewRatingUser1.mode = [Constants instance].RatingMode.DisplayUser;
			cell.viewRatingUser1.rating = topListsItem.userRating;
		}
		
		i = i + 1;
		
		if (i < array.count)
		{
			TopListsItem *topListsItem = [array objectAtIndex: i];
			
			cell.viewRatingUser2.mazeId = topListsItem.mazeId;
			
			cell.nameLabel2.textColor = [Styles instance].mazeList.textColor;
			cell.nameLabel2.text = topListsItem.mazeName;
						
			cell.dateLabel2.textColor = [Styles instance].mazeList.textColor;
			cell.dateLabel2.text = topListsItem.dateLastMod;
			
			cell.viewRatingAvg2.backgroundColor = [Colors instance].transparentColor;
			cell.lblNumRatings2.textColor = [Styles instance].mazeList.textColor;
			if (topListsItem.avgRating == 0.0)
			{
				cell.viewRatingAvg2.Mode = [Constants instance].RatingMode.DoNothing;
				
				cell.lblNumRatings2.text = @"";				
			}
			else 
			{
				cell.viewRatingAvg2.mode = [Constants instance].RatingMode.DisplayAvg;
				cell.viewRatingAvg2.rating = topListsItem.avgRating;
				
				cell.lblNumRatings2.text = [NSString stringWithFormat: @"%d ratings", topListsItem.numRatings];
			}
			
			cell.viewRatingUser2.backgroundColor = [Colors instance].transparentColor;
			if (topListsItem.started == NO)
			{
				cell.viewRatingUser2.Mode = [Constants instance].RatingMode.DoNothing;
			}
			else
			{
				cell.viewRatingUser2.mode = [Constants instance].RatingMode.DisplayUser;
				cell.viewRatingUser2.rating = topListsItem.userRating;
			}
		}
		else 
		{
			cell.viewRatingUser2.MazeId = 0;

			cell.imageViewBackground2.hidden = YES;
			
			cell.nameLabel2.text = @"";
			cell.dateLabel2.text = @"";

			cell.viewRatingAvg2.backgroundColor = [Colors instance].transparentColor;
			cell.viewRatingAvg2.Mode = [Constants instance].RatingMode.DoNothing;
			
			cell.lblNumRatings2.text = @"";

			cell.viewRatingUser2.backgroundColor = [Colors instance].transparentColor;
			cell.viewRatingUser2.Mode = [Constants instance].RatingMode.DoNothing;
		}
	}
	
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	TopListsTableViewCell *cell = (TopListsTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.touchColumn - 1);
	
	if (i < array.count)
	{
		TopListsItem *topListsItem = [array objectAtIndex: i];
		
		[Globals instance].gameViewController.topListsItem = topListsItem;
		
		[self.navigationController pushViewController: [Globals instance].gameViewController animated: YES];
	}
}

- (void)bannerView: (ADBannerView *)banner didFailToReceiveAdWithError: (NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
	NSLog(@"Maze List View Controller received a memory warning.");
}

- (void)viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];
	
	NSNumber *free = (NSNumber *)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"Free"];
	if ([free boolValue] == YES)
	{
		[Globals instance].bannerView.delegate = nil;
		[[Globals instance].bannerView removeFromSuperview];
	}
}

@end

