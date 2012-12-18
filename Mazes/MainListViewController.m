//
//  MainListViewController.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainListViewController.h"

#import "Colors.h"
#import "Game.h"
#import "GameViewController.h"
#import "MainListTableViewCell.h"
#import "WebServices.h"

@implementation MainListViewController

+ (MainListViewController *)shared
{
	static MainListViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[MainListViewController alloc] initWithNibName: @"MainListViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        array = [[NSMutableArray alloc] init];
        
        self->highestRatedWebServices = [[WebServices alloc] init];
        self->newestWebServices = [[WebServices alloc] init];
        self->yoursRatedWebServices = [[WebServices alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.backgroundColor = [Styles shared].mazeList.tableBackgroundColor;
	
	self->selectedSegmentIndex = 0;
	[self setupSegmentsWithSelectedIndex: 1];
	
	MainListItem *mainListItem = [[MainListItem alloc] init];
	mainListItem.MazeId = 0;
	[Globals shared].gameViewController.mainListItem = mainListItem;
    
    [self getHighestRatedList];
}

- (void)getHighestRatedList
{
    [self->highestRatedWebServices getHighestRatedWithDelegate: self userId: 64];
}

- (void)webServicesGetHighestRated: (NSArray *)hightestRatedMainListItems error: (NSError *)error
{
    if (error == nil)
    {
        self->highestRatedMazeListItems = hightestRatedMainListItems;
    }
    else
    {
        [self performSelector: @selector(getHighestRatedList) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
    }
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    [Game shared].bannerView.frame = CGRectMake([Game shared].bannerView.frame.origin.x,
                                                self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                                [Game shared].bannerView.frame.size.width,
                                                [Game shared].bannerView.frame.size.height);
    
    [self.view addSubview: [Game shared].bannerView];
}

- (void)viewDidAppear: (BOOL)animated
{
	[super viewDidAppear: animated];

	if ([Globals shared].gameViewController.mainListItem.mazeId != 0)
	{
        MainListItem *mainListItem = [[MainListItem alloc] init];
		mainListItem.MazeId = 0;
		[Globals shared].gameViewController.mainListItem = mainListItem;
		
		[[Globals shared].gameViewController.mapView clearMap];
		
		[[Globals shared].gameViewController clearMessage];
				
		[[Globals shared].gameViewController.mazeView clearMaze];
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
		self.imageViewHighestRated.image = [UIImage imageNamed: @"btnHighestRatedOrange.png"];
    }
	else
    {
		self.imageViewHighestRated.image = [UIImage imageNamed: @"btnHighestRatedBlue.png"];
    }
		
	if (selectedSegmentIndex == 2)
    {
		self.imageViewNewest.image = [UIImage imageNamed: @"btnNewestOrange.png"];
    }
	else
    {
		self.imageViewNewest.image = [UIImage imageNamed: @"btnNewestBlue.png"];
    }

	if (selectedSegmentIndex == 3)
    {
		self.imageViewYours.image = [UIImage imageNamed: @"btnYoursOrange.png"];
    }
	else
    {
		self.imageViewYours.image = [UIImage imageNamed: @"btnYoursBlue.png"];
    }
}

// Tab Bar

- (IBAction)btnCreateTouchDown: (id)sender
{
	[self.navigationController pushViewController:(UIViewController *)[Globals shared].editViewController animated: NO];
}

// Maze Lists

- (void)loadMazeList
{
    /*
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
    */
}	

- (void)loadMazeListResponse
{
    /*
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
    */
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
    
    MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed: @"TopListsTableViewCell" owner: self options: nil];
		cell = self.tableViewCell;
		
		self.tableViewCell = nil;
    }
    
	if (array.count > 0)
	{	
		int i = indexPath.row * 2;

		MainListItem *mainListItem = [array objectAtIndex: i];
		
		cell.viewRatingUser1.mazeId = mainListItem.mazeId;
		
		cell.nameLabel1.textColor = [Styles shared].mazeList.textColor;
		cell.nameLabel1.text = mainListItem.mazeName;
		
		cell.dateLabel1.textColor = [Styles shared].mazeList.textColor;
		cell.dateLabel1.text = [mainListItem.lastModified description];
		
		cell.viewRatingAvg1.backgroundColor = [Colors shared].transparentColor;
		cell.lblNumRatings1.textColor = [Styles shared].mazeList.textColor;
		if (mainListItem.averageRating == 0.0)
		{
			cell.viewRatingAvg1.Mode = [Constants shared].RatingMode.DoNothing;

			cell.lblNumRatings1.text = @"";
		}
		else 
		{
			cell.viewRatingAvg1.Mode = [Constants shared].RatingMode.DisplayAvg;
			cell.viewRatingAvg1.rating = mainListItem.averageRating;
			
			cell.lblNumRatings1.text = [NSString stringWithFormat: @"%d ratings", mainListItem.ratingsCount];
		}
		
		cell.viewRatingUser1.backgroundColor = [Colors shared].transparentColor;
		if (mainListItem.userStarted == NO)
		{
			cell.viewRatingUser1.Mode = [Constants shared].RatingMode.DoNothing;
		}
		else
		{
			cell.viewRatingUser1.mode = [Constants shared].RatingMode.DisplayUser;
			cell.viewRatingUser1.rating = mainListItem.userRating;
		}
		
		i = i + 1;
		
		if (i < array.count)
		{
			MainListItem *mainListItem = [array objectAtIndex: i];
			
			cell.viewRatingUser2.mazeId = mainListItem.mazeId;
			
			cell.nameLabel2.textColor = [Styles shared].mazeList.textColor;
			cell.nameLabel2.text = mainListItem.mazeName;
						
			cell.dateLabel2.textColor = [Styles shared].mazeList.textColor;
			cell.dateLabel2.text = [mainListItem.lastModified description];
			
			cell.viewRatingAvg2.backgroundColor = [Colors shared].transparentColor;
			cell.lblNumRatings2.textColor = [Styles shared].mazeList.textColor;
			if (mainListItem.averageRating == 0.0)
			{
				cell.viewRatingAvg2.Mode = [Constants shared].RatingMode.DoNothing;
				
				cell.lblNumRatings2.text = @"";				
			}
			else 
			{
				cell.viewRatingAvg2.mode = [Constants shared].RatingMode.DisplayAvg;
				cell.viewRatingAvg2.rating = mainListItem.averageRating;
				
				cell.lblNumRatings2.text = [NSString stringWithFormat: @"%d ratings", mainListItem.ratingsCount];
			}
			
			cell.viewRatingUser2.backgroundColor = [Colors shared].transparentColor;
			if (mainListItem.userStarted == NO)
			{
				cell.viewRatingUser2.Mode = [Constants shared].RatingMode.DoNothing;
			}
			else
			{
				cell.viewRatingUser2.mode = [Constants shared].RatingMode.DisplayUser;
				cell.viewRatingUser2.rating = mainListItem.userRating;
			}
		}
		else 
		{
			cell.viewRatingUser2.MazeId = 0;

			cell.imageViewBackground2.hidden = YES;
			
			cell.nameLabel2.text = @"";
			cell.dateLabel2.text = @"";

			cell.viewRatingAvg2.backgroundColor = [Colors shared].transparentColor;
			cell.viewRatingAvg2.Mode = [Constants shared].RatingMode.DoNothing;
			
			cell.lblNumRatings2.text = @"";

			cell.viewRatingUser2.backgroundColor = [Colors shared].transparentColor;
			cell.viewRatingUser2.Mode = [Constants shared].RatingMode.DoNothing;
		}
	}
	
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.touchColumn - 1);
	
	if (i < array.count)
	{
		MainListItem *mainListItem = [array objectAtIndex: i];
		
		[Globals shared].gameViewController.mainListItem = mainListItem;
		
		[self.navigationController pushViewController: [Globals shared].gameViewController animated: YES];
	}
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
	NSLog(@"Maze List View Controller received a memory warning.");
}

- (void)viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];

	[[Game shared].bannerView removeFromSuperview];
}

@end

