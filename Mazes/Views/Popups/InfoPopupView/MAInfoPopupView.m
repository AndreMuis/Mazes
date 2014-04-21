//
//  MAInfoPopupView.m
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAInfoPopupView.h"

#import "MAButton.h"
#import "MAInfoPopupStyle.h"
#import "MAStyles.h"

@interface MAInfoPopupView ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet MAButton *cancelButton;

@property (readonly, strong, nonatomic) UIView *parentView;
@property (readonly, strong, nonatomic) NSString *message;
@property (readonly, strong, nonatomic) NSString *cancelButtonTitle;

@end

@implementation MAInfoPopupView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        _styles = [MAStyles styles];
    }
    
    return self;
}

+ (MAInfoPopupView *)infoPopupViewWithParentView: (UIView *)parentView
                                         message: (NSString *)message
                               cancelButtonTitle: (NSString *)cancelButtonTitle
{
    MAInfoPopupView *infoPopupView = [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner: nil options: nil] objectAtIndex: 0];
    
    [infoPopupView setupWithParentView: parentView
                               message: message
                     cancelButtonTitle: cancelButtonTitle];
    
    return infoPopupView;
}

- (void)setupWithParentView: (UIView *)parentView
                    message: (NSString *)message
          cancelButtonTitle: (NSString *)cancelButtonTitle
{
    [super setupWithParentView: parentView];
    
    _parentView = parentView;
    _message = message;
    _cancelButtonTitle = cancelButtonTitle;
}

- (void)showWithDismissedHandler: (PopupViewDismissedHandler)dismissedHandler
{
    [super showWithDismissedHandler: dismissedHandler];
    
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.messageLabel.textColor = self.styles.infoPopup.textColor;
    self.messageLabel.font = self.styles.infoPopup.font;
    
    self.messageLabel.text = self.message;
   
    CGSize messageLabelSize = [self messageLabelSize];

    self.frame = CGRectMake(0.0,
                            0.0,
                            self.frame.size.width + (messageLabelSize.width - self.messageLabel.frame.size.width),
                            self.frame.size.height + (messageLabelSize.height - self.messageLabel.frame.size.height));
    
    self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x,
                                         self.messageLabel.frame.origin.y,
                                         messageLabelSize.width,
                                         messageLabelSize.height);
    
    self.cancelButton.titleEdgeInsets = self.styles.infoPopup.cancelButtonTitleEdgeInsets;
    [self.cancelButton setTitle: self.cancelButtonTitle forState: UIControlStateNormal];

    CGFloat cancelButtonWidth = [self cancelButtonWidth: self.cancelButton];
    
    self.cancelButton.frame = CGRectMake((self.bounds.size.width - cancelButtonWidth) / 2.0,
                                         self.cancelButton.frame.origin.y,
                                         cancelButtonWidth,
                                         self.cancelButton.frame.size.height);

    [self centerInParentView];
    [self animateUp];
}

- (CGSize)messageLabelSize
{
    NSDictionary *attributes = @{NSFontAttributeName : self.styles.infoPopup.font};

    CGRect messageLabelBounds = [self.message boundingRectWithSize: CGSizeMake(self.messageLabel.frame.size.width, 10000.0)
                                                           options: NSStringDrawingUsesLineFragmentOrigin
                                                        attributes: attributes
                                                           context: nil];
    
    if (messageLabelBounds.size.height > self.messageLabel.frame.size.height)
    {
        CGFloat messageLabelArea = ceilf(messageLabelBounds.size.width) * ceilf(messageLabelBounds.size.height);

        CGFloat messageLabelAspectRatio = self.messageLabel.frame.size.width / self.messageLabel.frame.size.height;

        CGFloat suggestedWidth = sqrtf(messageLabelArea * messageLabelAspectRatio);

        messageLabelBounds = [self.message boundingRectWithSize: CGSizeMake(suggestedWidth, 10000.0)
                                                        options: NSStringDrawingUsesLineFragmentOrigin
                                                     attributes: attributes
                                                        context: nil];
    }
    
    if (messageLabelBounds.size.width < self.messageLabel.frame.size.width)
    {
        messageLabelBounds.size.width = self.messageLabel.frame.size.width;
    }
    
    CGSize messageLabelSize = CGSizeMake(ceilf(messageLabelBounds.size.width),
                                         ceilf(messageLabelBounds.size.height));
    
    return messageLabelSize;
}

- (IBAction)cancelButtonTouchDown: (id)sender
{
    [self animateDown];
}

@end
















