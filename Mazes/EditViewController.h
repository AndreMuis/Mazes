//
//  EditViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"
#import "MALocation.h"
#import "MAViewController.h"

@class GridView;
@class MAEvent;
@class MAMaze;

@interface EditViewController : MAViewController <
    UIGestureRecognizerDelegate,
    UITableViewDelegate,
    UITextViewDelegate,
    UITextFieldDelegate,
    UIAlertViewDelegate,
    UIPopoverControllerDelegate>

@property (strong, nonatomic) MAMaze *maze;

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *wallButton;
@property (weak, nonatomic) IBOutlet UIButton *graphicsButton;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tutorialSwitch;

@property (weak, nonatomic) IBOutlet UIScrollView *locationScrollView;

@property (weak, nonatomic) IBOutlet UITableView *locationTypeTableView;
@property (weak, nonatomic) IBOutlet UITableView *directionTableView;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *messageDisplaysLabel;

@property (weak, nonatomic) IBOutlet UIImageView *floorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ceilingImageView;

@property (weak, nonatomic) IBOutlet UIView *wallView;

@property (weak, nonatomic) IBOutlet UITableView *wallTypeTableView;

@property (weak, nonatomic) IBOutlet UIImageView *wallImageView;

@property (weak, nonatomic) IBOutlet UIView *graphicsView;

@property (weak, nonatomic) IBOutlet UIImageView *wallDefaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *floorDefaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ceilingDefaultImageView;

@property (weak, nonatomic) IBOutlet UIView *audioView;

@property (weak, nonatomic) IBOutlet UITableView *backgroundSoundTableView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UILabel *message1Label;
@property (weak, nonatomic) IBOutlet UILabel *message2Label;

@property (weak, nonatomic) IBOutlet GridView *gridView;

+ (EditViewController *)shared;

- (IBAction)mainButtonTouchDown: (id)sender;
- (IBAction)locationButtonTouchDown: (id)sender;
- (IBAction)wallButtonTochhDown: (id)sender;
- (IBAction)graphicsButtonTouchDown: (id)sender;
- (IBAction)audioButtonTouchDown: (id)sender;

- (IBAction)switchPublicValueChanged: (id)sender;

- (IBAction)floorButtonTouchDown;
- (IBAction)ceilingButtonTouchDown;

- (IBAction)wallButtonTouchDown;

- (IBAction)wallDefaultButtonTouchDown;
- (IBAction)floorDefaultButtonTouchDown;
- (IBAction)ceilingDefaultButtonTouchDown;

- (IBAction)saveButtonTouchDown: (id)sender;

- (IBAction)deleteButtonTouchDown: (id)sender;

- (IBAction)mazesButtonTouchDown: (id)sender;

- (IBAction)swtichTutorialValueChanged: (id)sender;

@end

