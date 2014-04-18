//
//  MAButton.m
//  Mazes
//
//  Created by Andre Muis on 4/17/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAButton.h"

#import "MAButtonStyle.h"
#import "MAStyles.h"

@interface MAButton ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@end

@implementation MAButton

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];

    if (self)
    {
        _styles = [MAStyles styles];
    }

    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = self.styles.button.backgroundColor;
    
    self.layer.borderWidth = self.styles.button.borderWidth;
    self.layer.borderColor = self.styles.button.borderColor.CGColor;

    self.layer.cornerRadius = self.styles.button.cornerRadius;
    self.layer.masksToBounds = YES;
    
    [self setTitleColor: self.styles.button.titleColor forState: UIControlStateNormal];
    self.titleLabel.font = self.styles.button.titleFont;
}

@end
