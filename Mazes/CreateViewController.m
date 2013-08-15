//
//  CreateViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "CreateViewController.h"

#import "EditViewController.h"
#import "GridView.h"

#import "MAConstants.h"
#import "MAMainViewController.h"
#import "MAMaze.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"

@implementation CreateViewController

+ (CreateViewController *)shared
{
	static CreateViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[CreateViewController alloc] initWithNibName: @"CreateViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reset];
}

- (void)reset
{
	[EditViewController shared].maze.rows = [MAConstants shared].rowsMin;
	[EditViewController shared].maze.columns = [MAConstants shared].columnsMin;
	
    [[EditViewController shared].maze populateWithRows: [EditViewController shared].maze.rows
                                               columns: [EditViewController shared].maze.columns];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.gridView.maze = [EditViewController shared].maze;
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)thePickerView 
{	
	return 2;
}

- (CGFloat)pickerView: (UIPickerView *)pickerView widthForComponent: (NSInteger)component
{
	float width = 0.0;

	switch (component)
    {
        case 0:
            width = 100.0;
            break;
            
        case 1:
            width = 132.0;
            break;

        default:
            [MAUtilities logWithClass: [self class] format: @"component set to an illegal value: %d", component];
            break;
    }
    
	return width;
}

- (NSInteger)pickerView: (UIPickerView *)thePickerView numberOfRowsInComponent: (NSInteger)component 
{	
	int rowCount = 0;
	
	switch (component)
    {
        case 0:
            rowCount = ([MAConstants shared].rowsMax - [MAConstants shared].rowsMin) + 1;
            break;
            
        case 1:
            rowCount = ([MAConstants shared].columnsMax - [MAConstants shared].columnsMin) + 1;
            break;
    }
	
	return rowCount;
}

- (NSString *)pickerView: (UIPickerView *)thePickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component 
{	
	NSString *title = @"";
	
	switch (component)
    {
        case 0:
            title = [NSString stringWithFormat: @"%d", [MAConstants shared].rowsMin + row];
            break;
            
        case 1:
            title = [NSString stringWithFormat: @"%d", [MAConstants shared].columnsMin + row];
            break;
    }

	return title;
}

- (void)pickerView: (UIPickerView *)thePickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component 
{	
	switch (component)
    {
        case 0:
            [EditViewController shared].maze.rows = [MAConstants shared].rowsMin + row;
            break;
            
        case 1:
            [EditViewController shared].maze.columns = [MAConstants shared].columnsMin + row;
            break;
    }
    
    [[EditViewController shared].maze populateWithRows: [EditViewController shared].maze.rows
                                               columns: [EditViewController shared].maze.columns];
    
	[self.gridView setNeedsDisplay];
}

- (IBAction)continueButtonTouchDown: (id)sender
{
    [[MAMainViewController shared] transitionFromViewController: self
                                               toViewController: [EditViewController shared]
                                                     transition: MATransitionCrossDissolve];
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
    [[MAMainViewController shared] transitionFromViewController: self
                                               toViewController: [MATopMazesViewController shared]
                                                     transition: MATransitionCrossDissolve];
}

@end















