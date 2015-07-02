//
//  MATopMazesCollectionViewCell.m
//  Mazes
//
//  Created by Andre Muis on 6/30/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MATopMazesCollectionViewCell.h"

#import "MARatingView.h"
#import "MARatingViewDelegate.h"
#import "MAStyles.h"
#import "MATopMazesScreenStyle.h"

@interface MATopMazesCollectionViewCell () <MARatingViewDelegate>

@property (readwrite, weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (readwrite, weak, nonatomic) IBOutlet MARatingView *averageRatingView;
@property (readwrite, weak, nonatomic) IBOutlet UILabel *ratingCountLabel;
@property (readwrite, weak, nonatomic) IBOutlet MARatingView *userRatingView;
@property (readwrite, weak, nonatomic) IBOutlet UILabel *modifiedDateLabel;

@property (readonly, strong, nonatomic) MAStyles *styles;

@end

@implementation MATopMazesCollectionViewCell

+ (UINib *)nib
{
    UINib *nib = [UINib nibWithNibName: NSStringFromClass([self class])
                                bundle: nil];
    
    return nib;
}

+ (NSString *)resuseIdentifier
{
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    
    return reuseIdentifier;
}

- (instancetype)initWithCoder: (NSCoder *)coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        _styles = [MAStyles styles];
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.nameLabel.textColor = self.styles.topMazesScreen.textColor;
    
    [self.averageRatingView setupWithDelegate: self
                                       rating: 3.5
                                    starColor: [UIColor redColor]
                                 outlineWidth: 1.0];
    
    self.averageRatingView.userInteractionEnabled = NO;
    
    self.ratingCountLabel.textColor = self.styles.topMazesScreen.textColor;

    [self.userRatingView setupWithDelegate: self
                                    rating: 4.5
                                 starColor: [UIColor blueColor]
                              outlineWidth: 1.0];
    
    self.modifiedDateLabel.textColor = self.styles.topMazesScreen.textColor;
    
}


/*
- (void)setupWithDelegate: (id<MATopMazeTableViewCellDelegate>)delegate
             mazeSummary1: (MAMazeSummary *)mazeSummary1
{
    self.backgroundColor = [UIColor clearColor];
    
    _delegate = delegate;
    
    _mazeSummary1 = mazeSummary1;
    _mazeSummary2 = mazeSummary2;
    
    self.name1Label.textColor = self.styles.topMazesScreen.textColor;
    self.name1Label.text = self.mazeSummary1.name;
    
    self.date1Label.textColor = self.styles.topMazesScreen.textColor;
    self.date1Label.text = self.mazeSummary1.modifiedAtFormatted;
    
    self.ratingCount1Label.textColor = self.styles.topMazesScreen.textColor;
    
    if (self.mazeSummary1.averageRating == -1.0)
    {
        self.averageRating1View.hidden = YES;
        
        self.ratingCount1Label.text = @"";
    }
    else
    {
        self.averageRating1View.hidden = NO;
        
        
        self.ratingCount1Label.text = [NSString stringWithFormat: @"%d ratings", (int)self.mazeSummary1.ratingCount];
    }
    
    if (self.mazeSummary1.userStarted == NO)
    {
        self.userRating1View.hidden = YES;
    }
    else
    {
        self.userRating1View.hidden = NO;
        
    }
}
*/

- (void)ratingView: (MARatingView *)ratingView
  didTapWithRating: (float)rating
{
    NSLog(@"%f", rating);
}

@end






















