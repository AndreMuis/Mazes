//
//  MACreateViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MACreateViewController.h"

#import "MAConstants.h"
#import "MADesignViewController.h"
#import "MAGridView.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MAMaze.h"
#import "MASize.h"
#import "MATextureManager.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"

@interface MACreateViewController ()

@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;
@property (readonly, strong, nonatomic) MAStyles *styles;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet MAGridView *gridView;

@end

@implementation MACreateViewController

- (id)initWithMazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
                   styles: (MAStyles *)styles
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _mazeManager = mazeManager;
        _textureManager = textureManager;
        _styles = styles;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.maze = self.maze;
    self.gridView.styles = self.styles;
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
            rowCount = (MARowsMax - MARowsMin) + 1;
            break;
            
        case 1:
            rowCount = (MAColumnsMax - MAColumnsMin) + 1;
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
            title = [NSString stringWithFormat: @"%d", MARowsMin + row];
            break;
            
        case 1:
            title = [NSString stringWithFormat: @"%d", MAColumnsMin + row];
            break;
    }

	return title;
}

- (void)pickerView: (UIPickerView *)thePickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component 
{	
	switch (component)
    {
        case 0:
            self.maze.rows = MARowsMin + row;
            break;
            
        case 1:
            self.maze.columns = MAColumnsMin + row;
            break;
    }
    
    [self.maze populateLocationsAndWalls];
    
	[self.gridView refresh];
}

- (IBAction)continueButtonTouchDown: (id)sender
{
    self.mazeManager.isFirstUserMazeSizeChosen = YES;
    
    self.designViewController.maze = self.maze;
    
    [self.mainViewController transitionFromViewController: self
                                         toViewController: self.designViewController
                                               transition: MATransitionCrossDissolve];
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
    [self.mainViewController transitionFromViewController: self
                                         toViewController: self.topMazesViewController
                                               transition: MATransitionCrossDissolve];
}

@end















