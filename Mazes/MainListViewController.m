//
//  MainListViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MainListViewController.h"

#import "Colors.h"
#import "Game.h"
#import "GameViewController.h"
#import "MainListItem.h" 
#import "MainListTableViewCell.h"
#import "MainViewController.h"
#import "MapView.h"
#import "MazeView.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "RatingView.h"
#import "ServerOperations.h"
#import "Styles.h"
#import "Utilities.h"

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
        self->operationQueue = [[NSOperationQueue alloc] init];

        self->setupOperationQueueEvent = [[MAEvent alloc] initWithTarget: self
                                                                  action: @selector(setupOperationQueue)
                                                            intervalSecs: [Constants shared].serverRetryDelaySecs
                                                                 repeats: NO];
        
        self->highestRatedMainListItems = [NSArray array];
        self->highestRatedListHasLoaded = NO;
        
        self->newestMainListItems = [NSArray array];
        self->newestMainListHasLoaded = NO;
        
        self->yoursMainListItems = [NSArray array];
        self->yoursMainListHasLoaded = NO;
        
        self->selectedSegmentIndex = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self->selectedSegmentIndex = 0;
	[self refreshSegments];

	self.tableView.backgroundColor = [Styles shared].mazeList.tableBackgroundColor;

    [Game shared].bannerView.frame = CGRectMake([Game shared].bannerView.frame.origin.x,
                                                self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                                [Game shared].bannerView.frame.size.width,
                                                [Game shared].bannerView.frame.size.height);
    
    [self.view addSubview: [Game shared].bannerView];
    
    [self setupOperationQueue];
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    if (self->movingToParentViewController == YES)
    {
        if ([[Game shared].bannerView isDescendantOfView: self.view] == NO)
        {
            [Game shared].bannerView.frame = CGRectMake([Game shared].bannerView.frame.origin.x,
                                                        self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                                        [Game shared].bannerView.frame.size.width,
                                                        [Game shared].bannerView.frame.size.height);
            
            [self.view addSubview: [Game shared].bannerView];
        }
    }
}

- (void)serverOperationsHighestRatedList: (NSArray *)mainListItems error: (NSError *)error
{
    if (error == nil)
    {
        NSLog(@"highest rated");
        
        self->highestRatedMainListItems = mainListItems;
        
        if (self->highestRatedListHasLoaded == NO)
        {
            self->highestRatedListHasLoaded = YES;
            
            if (self->selectedSegmentIndex == 0)
            {
                self.activityIndicatorView.hidden = YES;
                [self.activityIndicatorView stopAnimating];
            }
        }
        
        if (self->selectedSegmentIndex == 0)
        {
            [self.tableView reloadData];
        }
    }
    else
    {
        if (self->selectedSegmentIndex == 0)
        {
            [[MAEvents shared] addEvent: self->setupOperationQueueEvent];
        }
    }
}

- (void)serverOperationsNewestList: (NSArray *)mainListItems error: (NSError *)error
{
    if (error == nil)
    {
        NSLog(@"newest");
        
        self->newestMainListItems = mainListItems;
        
        if (self->newestMainListHasLoaded == NO)
        {
            self->newestMainListHasLoaded = YES;
            
            if (self->selectedSegmentIndex == 1)
            {
                self.activityIndicatorView.hidden = YES;
                [self.activityIndicatorView stopAnimating];
            }
        }

        if (self->selectedSegmentIndex == 1)
        {
            [self.tableView reloadData];
        }
    }
    else
    {
        if (self->selectedSegmentIndex == 1)
        {
            [[MAEvents shared] addEvent: self->setupOperationQueueEvent];
        }
    }
}

- (void)serverOperationsYoursList: (NSArray *)mainListItems error: (NSError *)error
{
    if (error == nil)
    {
        NSLog(@"yours");
        
        self->yoursMainListItems = mainListItems;
        
        if (self->yoursMainListHasLoaded == NO)
        {
            self->yoursMainListHasLoaded = YES;
            
            if (self->selectedSegmentIndex == 2)
            {
                self.activityIndicatorView.hidden = YES;
                [self.activityIndicatorView stopAnimating];
            }
        }
        
        if (self->selectedSegmentIndex == 2)
        {
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        if (self->selectedSegmentIndex == 2)
        {
            [[MAEvents shared] addEvent: self->setupOperationQueueEvent];
        }
    }
}

- (void)setupOperationQueue
{
    [self->operationQueue cancelAllOperations];
    
    RKObjectRequestOperation *highestRatedOperation = [[ServerOperations shared] highestRatedOperationWithDelegate: self userId: 64];
    RKObjectRequestOperation *newestOperation = [[ServerOperations shared] newestOperationWithDelegate: self userId: 64];
    RKObjectRequestOperation *yoursOperation = [[ServerOperations shared] yoursOperationWithDelegate: self userId: 64];
    
    NSArray *operations = @[highestRatedOperation, newestOperation, yoursOperation];
    
    RKObjectRequestOperation *currentOperation = nil;
    
    switch (self->selectedSegmentIndex)
    {
        case 0:
            currentOperation = highestRatedOperation;
            break;
            
        case 1:
            currentOperation = newestOperation;
            break;
            
        case 2:
            currentOperation = yoursOperation;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"selectedSegmentIndex set to an illegal value: %d", self->selectedSegmentIndex];
            break;
    }

    [self->operationQueue addOperation: currentOperation];

    for (RKObjectRequestOperation *operation in operations)
    {
        if (operation != currentOperation)
        {
            NSArray *mainListItems;
            
            if (operation == highestRatedOperation)
            {
                mainListItems = self->highestRatedMainListItems;
            }
            else if (operation == newestOperation)
            {
                mainListItems = self->newestMainListItems;
            }
            else if (operation == yoursOperation)
            {
                mainListItems = self->yoursMainListItems;
            }
            
            if (mainListItems.count == 0)
            {
                [operation addDependency: currentOperation];
            
                [self->operationQueue addOperation: operation];
            }
        }
    }
    
    if ((self->selectedSegmentIndex == 0 && self->highestRatedListHasLoaded == NO) ||
        (self->selectedSegmentIndex == 1 && self->newestMainListHasLoaded == NO) ||
        (self->selectedSegmentIndex == 2 && self->yoursMainListHasLoaded == NO))
    {
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    }
    else
    {
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
    }
}

// Segmented Control

- (IBAction)btnHighestRatedTouchDown: (id)sender
{	
	if (self->selectedSegmentIndex != 0)
	{
        self->selectedSegmentIndex = 0;
		[self refreshSegments];

		[self.tableView reloadData];
        
        [self setupOperationQueue];
	}
}

- (IBAction)btnNewestTouchDown: (id)sender
{
	if (self->selectedSegmentIndex != 1)
	{
        self->selectedSegmentIndex = 1;
		[self refreshSegments];
        
		[self.tableView reloadData];

        [self setupOperationQueue];
	}
}

- (IBAction)btnYoursTouchDown: (id)sender
{
	if (self->selectedSegmentIndex != 2)
	{
        self->selectedSegmentIndex = 2;
		[self refreshSegments];
        
		[self.tableView reloadData];
        
        [self setupOperationQueue];
	}
}

- (void)refreshSegments
{
	if (self->selectedSegmentIndex == 0)
    {
		self.imageViewHighestRated.image = [UIImage imageNamed: @"btnHighestRatedOrange.png"];
    }
	else
    {
		self.imageViewHighestRated.image = [UIImage imageNamed: @"btnHighestRatedBlue.png"];
    }
		
	if (self->selectedSegmentIndex == 1)
    {
		self.imageViewNewest.image = [UIImage imageNamed: @"btnNewestOrange.png"];
    }
	else
    {
		self.imageViewNewest.image = [UIImage imageNamed: @"btnNewestBlue.png"];
    }

	if (self->selectedSegmentIndex == 2)
    {
		self.imageViewYours.image = [UIImage imageNamed: @"btnYoursOrange.png"];
    }
	else
    {
		self.imageViewYours.image = [UIImage imageNamed: @"btnYoursBlue.png"];
    }
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section 
{
	NSInteger rows = 0;
	
    NSArray *mainListItems = [self currentMainListItems];
    
	if (mainListItems.count % 2 == 0)
    {
		rows = mainListItems.count / 2;
    }
	else if (mainListItems.count % 2 == 1)
    {
		rows = (mainListItems.count + 1)/ 2;
    }
	
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"MainListTableViewCell";
    
    MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed: @"MainListTableViewCell" owner: self options: nil];
		cell = self.tableViewCell;
		
		self.tableViewCell = nil;
    }
    
    NSArray *mainListItems = [self currentMainListItems];
    
	if (mainListItems.count > 0)
	{	
		int i = indexPath.row * 2;

		MainListItem *mainListItem = [mainListItems objectAtIndex: i];
		
		cell.viewRatingUser1.mazeId = mainListItem.mazeId;
		
		cell.nameLabel1.textColor = [Styles shared].mazeList.textColor;
		cell.nameLabel1.text = mainListItem.mazeName;
		
		cell.dateLabel1.textColor = [Styles shared].mazeList.textColor;
		cell.dateLabel1.text = mainListItem.lastModifiedFormatted;
		
		cell.viewRatingAvg1.backgroundColor = [Colors shared].transparentColor;
		cell.lblNumRatings1.textColor = [Styles shared].mazeList.textColor;
		if (mainListItem.averageRating == 0.0)
		{
			cell.viewRatingAvg1.mode = MARatingModeDoNothing;

			cell.lblNumRatings1.text = @"";
		}
		else 
		{
			cell.viewRatingAvg1.mode = MARatingModeDisplayAvg;
			cell.viewRatingAvg1.rating = mainListItem.averageRating;
			
			cell.lblNumRatings1.text = [NSString stringWithFormat: @"%d ratings", mainListItem.ratingsCount];
		}
		
		cell.viewRatingUser1.backgroundColor = [Colors shared].transparentColor;
		if (mainListItem.userStarted == NO)
		{
			cell.viewRatingUser1.Mode = MARatingModeDoNothing;
		}
		else
		{
			cell.viewRatingUser1.mode = MARatingModeDisplayUser;
			cell.viewRatingUser1.rating = mainListItem.userRating;
		}
		
		i = i + 1;
		
		if (i < mainListItems.count)
		{
			MainListItem *mainListItem = [mainListItems objectAtIndex: i];
			
			cell.viewRatingUser2.mazeId = mainListItem.mazeId;
			
			cell.nameLabel2.textColor = [Styles shared].mazeList.textColor;
			cell.nameLabel2.text = mainListItem.mazeName;
						
			cell.dateLabel2.textColor = [Styles shared].mazeList.textColor;
			cell.dateLabel2.text = mainListItem.lastModifiedFormatted;
			
			cell.viewRatingAvg2.backgroundColor = [Colors shared].transparentColor;
			cell.lblNumRatings2.textColor = [Styles shared].mazeList.textColor;
			if (mainListItem.averageRating == 0.0)
			{
				cell.viewRatingAvg2.Mode = MARatingModeDoNothing;
				
				cell.lblNumRatings2.text = @"";				
			}
			else 
			{
				cell.viewRatingAvg2.mode = MARatingModeDisplayAvg;
				cell.viewRatingAvg2.rating = mainListItem.averageRating;
				
				cell.lblNumRatings2.text = [NSString stringWithFormat: @"%d ratings", mainListItem.ratingsCount];
			}
			
			cell.viewRatingUser2.backgroundColor = [Colors shared].transparentColor;
			if (mainListItem.userStarted == NO)
			{
				cell.viewRatingUser2.Mode = MARatingModeDoNothing;
			}
			else
			{
				cell.viewRatingUser2.mode = MARatingModeDisplayUser;
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
			cell.viewRatingAvg2.Mode = MARatingModeDoNothing;
			
			cell.lblNumRatings2.text = @"";

			cell.viewRatingUser2.backgroundColor = [Colors shared].transparentColor;
			cell.viewRatingUser2.Mode = MARatingModeDoNothing;
		}
	}
	
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.touchColumn - 1);
	
    NSArray *mainListItems = [self currentMainListItems];
    
	if (i < mainListItems.count)
	{
        [GameViewController shared].mainListItem = [mainListItems objectAtIndex: i];
        
        [[MainViewController shared] transitionFromViewController: self
                                                 toViewController: [GameViewController shared]
                                                       transition: MATransitionFlipFromLeft];
    }
}

- (NSArray *)currentMainListItems
{
    switch (self->selectedSegmentIndex)
    {
        case 0:
            return self->highestRatedMainListItems;
            break;
            
        case 1:
            return self->newestMainListItems;
            break;
            
        case 2:
            return self->yoursMainListItems;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"selectedSegmentIndex set to an illegal value: %d", self->selectedSegmentIndex];
            return nil;
            break;
    }
}

- (IBAction)btnCreateTouchDown: (id)sender
{
	[self.navigationController pushViewController:(UIViewController *)[Globals shared].editViewController animated: NO];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
	NSLog(@"Maze List View Controller received a memory warning.");
}

@end

