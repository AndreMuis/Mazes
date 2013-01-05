//
//  MainListViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MainListViewController.h"

#import "ActivityViewStyle.h"
#import "AppDelegate.h"
#import "CurrentUser.h"
#import "EditViewController.h"
#import "GameViewController.h"
#import "MainListItem.h" 
#import "MainListTableViewCell.h"
#import "MainViewController.h"
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
        
        self->viewAppearingFirstTime = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self->selectedSegmentIndex = 0;
	[self refreshSegments];

	self.tableView.backgroundColor = [Styles shared].mainListView.tableBackgroundColor;

    self.activityIndicatorView.color = [Styles shared].activityView.color;
    
    if ([CurrentUser shared].id == 0)
    {
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    }
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    if (self->movingToParentViewController == YES || self->viewAppearingFirstTime == YES)
    {
        self->viewAppearingFirstTime = NO;
        
        if ([CurrentUser shared].id != 0)
        {
            [self setupOperationQueue];
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if ([appDelegate.bannerView isDescendantOfView: self.view] == NO)
        {
            appDelegate.bannerView.frame = CGRectMake(appDelegate.bannerView.frame.origin.x,
                                                      self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                                      appDelegate.bannerView.frame.size.width,
                                                      appDelegate.bannerView.frame.size.height);
            
            [self.view addSubview: appDelegate.bannerView];
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
            if ([[MAEvents shared] hasEvent: self->setupOperationQueueEvent] == NO)
            {
                [[MAEvents shared] addEvent: self->setupOperationQueueEvent];
            }
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
            if ([[MAEvents shared] hasEvent: self->setupOperationQueueEvent] == NO)
            {
                [[MAEvents shared] addEvent: self->setupOperationQueueEvent];
            }
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
            if ([[MAEvents shared] hasEvent: self->setupOperationQueueEvent] == NO)
            {
                [[MAEvents shared] addEvent: self->setupOperationQueueEvent];
            }
        }
    }
}

- (void)setupOperationQueue
{
    [self->operationQueue cancelAllOperations];

    if ([[MAEvents shared] hasEvent: self->setupOperationQueueEvent] == YES)
    {
        [[MAEvents shared] removeEvent: self->setupOperationQueueEvent];
    }
    
    RKObjectRequestOperation *highestRatedOperation = [[ServerOperations shared] highestRatedOperationWithDelegate: self
                                                                                                            userId: [CurrentUser shared].id];
    
    RKObjectRequestOperation *newestOperation = [[ServerOperations shared] newestOperationWithDelegate: self
                                                                                                userId: [CurrentUser shared].id];
    
    RKObjectRequestOperation *yoursOperation = [[ServerOperations shared] yoursOperationWithDelegate: self
                                                                                              userId: [CurrentUser shared].id];
    
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

        if ([CurrentUser shared].id != 0)
        {
            [self.tableView reloadData];
            
            [self setupOperationQueue];
        }
	}
}

- (IBAction)btnNewestTouchDown: (id)sender
{
	if (self->selectedSegmentIndex != 1)
	{
        self->selectedSegmentIndex = 1;
		[self refreshSegments];
        
        if ([CurrentUser shared].id != 0)
        {
            [self.tableView reloadData];

            [self setupOperationQueue];
        }
	}
}

- (IBAction)btnYoursTouchDown: (id)sender
{
	if (self->selectedSegmentIndex != 2)
	{
        self->selectedSegmentIndex = 2;
		[self refreshSegments];
        
        if ([CurrentUser shared].id != 0)
        {
            [self.tableView reloadData];
            
            [self setupOperationQueue];
        }
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
    
    MainListItem *mainListItem1 = [mainListItems objectAtIndex: 2 * indexPath.row];
    
    MainListItem *mainListItem2 = nil;
    if (2 * indexPath.row + 1 <= mainListItems.count - 1)
    {
        mainListItem2 = [mainListItems objectAtIndex: 2 * indexPath.row + 1];
    }
    
    [cell setupWithMainListItem1: mainListItem1 mainListItem2: mainListItem2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.selectedColumn - 1);
	
    NSArray *mainListItems = [self currentMainListItems];
    
	if (i < mainListItems.count)
	{
        if ([[MAEvents shared] hasEvent: self->setupOperationQueueEvent] == YES)
        {
            [[MAEvents shared] removeEvent: self->setupOperationQueueEvent];
        }
        
        MainListItem *mainListItem = [mainListItems objectAtIndex: i];
        
        [GameViewController shared].mazeId = mainListItem.mazeId;
        
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
    if ([CurrentUser shared].id != 0)
    {
        if ([[MAEvents shared] hasEvent: self->setupOperationQueueEvent] == YES)
        {
            [[MAEvents shared] removeEvent: self->setupOperationQueueEvent];
        }

        [self.navigationController pushViewController: [EditViewController shared] animated: NO];
    }
}

@end

