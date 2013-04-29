//
//  CreateViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "CreateViewController.h"

#import "Constants.h"
#import "EditViewController.h"
#import "GridView.h"
#import "MainListViewController.h"
#import "MainViewController.h"
#import "Maze.h"
#import "Utilities.h"

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

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	
	[EditViewController shared].maze.rows = [Constants shared].rowsMin;
	[EditViewController shared].maze.columns = [Constants shared].columnsMin;
	
    [[EditViewController shared].maze.locations populateWithRows: [EditViewController shared].maze.rows
                                                         columns: [EditViewController shared].maze.columns];
    
	[self.pickerView selectRow: 0 inComponent: 0 animated: NO];
	[self.pickerView selectRow: 0 inComponent: 1 animated: NO];
	
    self.gridView.maze = [EditViewController shared].maze;
	[self.gridView setNeedsDisplay];
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
            [Utilities logWithClass: [self class] format: @"component set to an illegal value: %d", component];
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
            rowCount = ([Constants shared].rowsMax - [Constants shared].rowsMin) + 1;
            break;
            
        case 1:
            rowCount = ([Constants shared].columnsMax - [Constants shared].columnsMin) + 1;
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
            title = [NSString stringWithFormat: @"%d", [Constants shared].rowsMin + row];
            break;
            
        case 1:
            title = [NSString stringWithFormat: @"%d", [Constants shared].columnsMin + row];
            break;
    }

	return title;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component 
{	
	switch (component)
    {
        case 0:
            [EditViewController shared].maze.rows = [Constants shared].rowsMin + row;
            break;
            
        case 1:
            [EditViewController shared].maze.columns = [Constants shared].columnsMin + row;
            break;
    }
    
    [[EditViewController shared].maze.locations populateWithRows: [EditViewController shared].maze.rows
                                                         columns: [EditViewController shared].maze.columns];
    
	[self.gridView setNeedsDisplay];
}

- (IBAction)continueButtonTouchDown: (id)sender
{
    [[MainViewController shared] transitionFromViewController: self
                                             toViewController: [EditViewController shared]
                                                   transition: MATransitionCrossDissolve];
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
    [EditViewController shared].maze.rows = 0;
    [EditViewController shared].maze.columns = 0;
    [[EditViewController shared].maze.locations removeAll];
    
    [[MainViewController shared] transitionFromViewController: self
                                             toViewController: [MainListViewController shared]
                                                   transition: MATransitionCrossDissolve];
}

@end















