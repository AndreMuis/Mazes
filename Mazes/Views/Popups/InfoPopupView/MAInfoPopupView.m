//
//  MAInfoPopupView.m
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAInfoPopupView.h"

#import "MAFoundExitPopupStyle.h"
#import "MAStyles.h"

@interface MAInfoPopupView ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MAInfoPopupView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
    }
    
    return self;
}

+ (MAInfoPopupView *)infoPopupView
{
    return [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner: nil options: nil] objectAtIndex: 0];
}

- (void)showWithStyles: (MAStyles *)styles
            parentView: (UIView *)parentView
               message: (NSString *)message
     cancelButtonTitle: (NSString *)cancelButtonTitle
      dismissedHandler: (PopupViewDismissedHandler)dismissedHandler;
{
    [super showWithStyles: styles
               parentView: parentView
         dismissedHandler: dismissedHandler];
    
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.messageLabel.textColor = self.styles.foundExitPopup.textColor;
    self.messageLabel.font = self.styles.foundExitPopup.font;
    
    self.messageLabel.text = message;
    
    [self.cancelButton setTitle: cancelButtonTitle forState: UIControlStateNormal];
    
    [parentView addSubview: self];
    
    [self animateUp];
}

- (IBAction)cancelButtonTouchDown: (id)sender
{
    [self animateDown];
}

@end
















