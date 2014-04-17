//
//  MACreateViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MACreateViewController.h"

#import "MACreateScreenStyle.h"
#import "MAConstants.h"
#import "MADesignViewController.h"
#import "MAFloorPlanView.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MAMaze.h"
#import "MASize.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"

@interface MACreateViewController ()

@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;
@property (readonly, strong, nonatomic) MAStyles *styles;

@property (weak, nonatomic) IBOutlet UIPickerView *rowsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *columnsPickerView;

@property (weak, nonatomic) IBOutlet MAFloorPlanView *floorPlanView;

@end

@implementation MACreateViewController

#pragma mark - MACreateViewController

- (id)initWithMazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _mazeManager = mazeManager;
        _textureManager = textureManager;
        _styles = [MAStyles styles];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.rowsPickerView.frame.size.width != self.styles.createScreen.pickerWidth)
    {
        [MAUtilities logWithClass: [self class] format: @"Rows pickerview width is %f. Should be %f", self.rowsPickerView.frame.size.width, self.styles.createScreen.pickerWidth];
    }

    if (self.columnsPickerView.frame.size.width != self.styles.createScreen.pickerWidth)
    {
        [MAUtilities logWithClass: [self class] format: @"Columns pickerview width is %f. Should be %f", self.columnsPickerView.frame.size.width, self.styles.createScreen.pickerWidth];
    }
    
    self.rowsPickerView.backgroundColor = self.styles.createScreen.pickerBackgroundColor;
    self.rowsPickerView.layer.borderColor = self.styles.createScreen.pickerBorderColor.CGColor;
    self.rowsPickerView.layer.borderWidth = self.styles.createScreen.pickerBorderWidth;
    
    self.columnsPickerView.backgroundColor = self.styles.createScreen.pickerBackgroundColor;
    self.columnsPickerView.layer.borderColor = self.styles.createScreen.pickerBorderColor.CGColor;
    self.columnsPickerView.layer.borderWidth = self.styles.createScreen.pickerBorderWidth;

    self.floorPlanView.maze = self.maze;
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

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)thePickerView
{	
	return 1;
}

- (CGFloat)pickerView: (UIPickerView *)pickerView widthForComponent: (NSInteger)component
{
	return self.styles.createScreen.pickerWidth;
}

- (CGFloat)pickerView: (UIPickerView *)pickerView rowHeightForComponent: (NSInteger)component
{
	return self.styles.createScreen.pickerRowHeight;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{	
	int rows = 0;
	
    if (pickerView == self.rowsPickerView)
    {
        rows = (MARowsMax - MARowsMin) + 1;
    }
    else if (pickerView == self.columnsPickerView)
    {
        rows = (MAColumnsMax - MAColumnsMin) + 1;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Pickerview not handled: %@", pickerView];
    }
	
	return rows;
}

- (UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0.0,
                                                                0.0,
                                                                pickerView.frame.size.width,
                                                                self.styles.createScreen.pickerRowHeight)];
    
    label.backgroundColor = self.styles.createScreen.pickerRowBackgroundColor;
    label.textColor = self.styles.createScreen.pickerRowTextColor;
    label.font = self.styles.createScreen.pickerRowFont;

    if (pickerView == self.rowsPickerView)
    {
        label.text = [NSString stringWithFormat:@"    %d", MARowsMin + row];
    }
    else if (pickerView == self.columnsPickerView)
    {
        label.text = [NSString stringWithFormat:@"    %d", MAColumnsMin + row];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Pickerview not handled: %@", pickerView];
    }

    return label;
}

- (void)pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{	
    if (pickerView == self.rowsPickerView)
    {
        self.maze.rows = MARowsMin + row;
    }
    else if (pickerView == self.columnsPickerView)
    {
        self.maze.columns = MAColumnsMin + row;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Pickerview not handled: %@", pickerView];
    }
    
    [self.maze populateLocationsAndWalls];
    
	[self.floorPlanView refresh];
}

@end















