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
#import "MAFloorPlanViewController.h"
#import "MALabel.h"
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

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIView *floorPlanBorderView;
@property (weak, nonatomic) IBOutlet UIView *floorPlanPlaceholderView;
@property (readonly, strong, nonatomic) MAFloorPlanViewController *floorPlanViewController;

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
        [MAUtilities logWithClass: [self class]
                          message: @"Rows pickerview width is invalid."
                       parameters: @{@"self.rowsPickerView.frame.size.width" : @(self.rowsPickerView.frame.size.width),
                                     @"self.styles.createScreen.pickerWidth" : @(self.styles.createScreen.pickerWidth)}];
    }

    if (self.columnsPickerView.frame.size.width != self.styles.createScreen.pickerWidth)
    {
        [MAUtilities logWithClass: [self class]
                          message: @"Columns pickerview width is invalid."
                       parameters: @{@"self.columnsPickerView.frame.size.width" : @(self.columnsPickerView.frame.size.width),
                                     @"self.styles.createScreen.pickerWidth" : @(self.styles.createScreen.pickerWidth)}];
    }
    
    self.rowsPickerView.backgroundColor = self.styles.createScreen.pickerBackgroundColor;
    self.rowsPickerView.layer.borderColor = self.styles.createScreen.pickerBorderColor.CGColor;
    self.rowsPickerView.layer.borderWidth = self.styles.createScreen.pickerBorderWidth;
    
    self.columnsPickerView.backgroundColor = self.styles.createScreen.pickerBackgroundColor;
    self.columnsPickerView.layer.borderColor = self.styles.createScreen.pickerBorderColor.CGColor;
    self.columnsPickerView.layer.borderWidth = self.styles.createScreen.pickerBorderWidth;

    self.messageLabel.backgroundColor = self.styles.createScreen.messageBackgroundColor;
    self.messageLabel.textColor = self.styles.createScreen.messageDisabledTextColor;

    self.floorPlanBorderView.backgroundColor = self.styles.createScreen.floorPlanBorderColor;
    
    _floorPlanViewController = [MAFloorPlanViewController floorPlanViewControllerWithMaze: self.maze
                                                                    floorPlanViewDelegate: nil];
                                
    [MAUtilities addChildViewController: self.floorPlanViewController
                 toParentViewController: self
                        placeholderView: self.floorPlanPlaceholderView];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.rowsPickerView selectRow: self.maze.rows - MARowsMin
                       inComponent: 0
                          animated: NO];
    
    [self.columnsPickerView selectRow: self.maze.columns - MAColumnsMin
                          inComponent: 0
                             animated: NO];
}

- (IBAction)continueButtonTouchDown: (id)sender
{
    if (self.mainViewController.isPerformingTransition == NO)
    {
        self.mazeManager.isFirstUserMazeSizeChosen = YES;
        
        self.designViewController.maze = self.maze;
        
        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.designViewController
                                                   transition: MATransitionTranslateBothLeft
                                                   completion: ^{}];
    }
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
    if (self.mainViewController.isPerformingTransition == NO)
    {
        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.topMazesViewController
                                                   transition: MATransitionTranslateBothRight
                                                   completion: ^{}];
    }
}

#pragma mark - UIPickerViewDelegate

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
        [MAUtilities logWithClass: [self class]
                          message: @"pickerview not handled."
                       parameters: @{@"pickerView" : pickerView}];
    }
    
    return rows;
}

- (UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    NSString *zeroZero = @"00";

    NSDictionary *attributes = @{NSFontAttributeName : self.styles.createScreen.pickerRowFont};
    CGSize zeroZeroSize = [zeroZero sizeWithAttributes: attributes];
    
    CGRect labelFrame = CGRectMake(0.0,
                                   0.0,
                                   pickerView.frame.size.width,
                                   self.styles.createScreen.pickerRowHeight);
    
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0.0,
                                                    (self.styles.createScreen.pickerWidth - zeroZeroSize.width) / 2.0,
                                                    0.0,
                                                    0.0);

    MALabel *label = [[MALabel alloc] initWithFrame: labelFrame edgeInsets: labelEdgeInsets];
    
    label.backgroundColor = self.styles.createScreen.pickerRowBackgroundColor;
    label.textColor = self.styles.createScreen.pickerRowTextColor;
    label.font = self.styles.createScreen.pickerRowFont;

    if (pickerView == self.rowsPickerView)
    {
        label.text = [NSString stringWithFormat: @"%d", MARowsMin + row];
    }
    else if (pickerView == self.columnsPickerView)
    {
        label.text = [NSString stringWithFormat: @"%d", MAColumnsMin + row];
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"pickerview not handled."
                       parameters: @{@"pickerView" : pickerView}];
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
        [MAUtilities logWithClass: [self class]
                          message: @"pickerview not handled."
                       parameters: @{@"pickerView" : pickerView}];
    }

    [self.maze populateLocationsAndWalls];
    
    if (self.floorPlanViewController.minimumZoomScale == 1.0)
    {
        self.messageLabel.textColor = self.styles.createScreen.messageDisabledTextColor;
    }
    else if (self.floorPlanViewController.minimumZoomScale < 1.0)
    {
        self.messageLabel.textColor = self.styles.createScreen.messageEnabledTextColor;
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"minimumZoomScale set to an illegal value."
                       parameters: @{@"self.floorPlanViewController.minimumZoomScale" : @(self.floorPlanViewController.minimumZoomScale)}];
    }
}

#pragma mark -

@end






























