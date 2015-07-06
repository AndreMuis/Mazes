//
//  MATopWorldCollectionViewCell.m
//  Mazes
//
//  Created by Andre Muis on 6/30/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MATopWorldCollectionViewCell.h"

#import "MACurrentUser.h"
#import "MARatingView.h"
#import "MARatingViewController.h"
#import "MAStyles.h"
#import "MATopMazesScreenStyle.h"
#import "MATopWorldCollectionViewCellDelegate.h"
#import "MAWorldRating.h"
#import "MAWorld.h"

@interface MATopWorldCollectionViewCell ()

@property (readwrite, weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (readwrite, weak, nonatomic) IBOutlet UIView *averageRatingContainerView;
@property (readwrite, weak, nonatomic) IBOutlet UILabel *ratingCountLabel;
@property (readwrite, weak, nonatomic) IBOutlet UIView *userRatingContainerView;
@property (readwrite, weak, nonatomic) IBOutlet UILabel *modifiedDateLabel;

@property (readonly, strong, nonatomic) MARatingView *averageRatingView;
@property (readonly, strong, nonatomic) MARatingView *userRatingView;

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (readonly, weak, nonatomic) id<MATopWorldCollectionViewCellDelegate> delegate;
@property (readonly, strong, nonatomic) MAWorld *world;

@end

@implementation MATopWorldCollectionViewCell

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
        _averageRatingView = [MARatingView ratingView];
        _userRatingView = [MARatingView ratingView];

        _styles = [MAStyles styles];
        
        _world = nil;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.nameLabel.textColor = self.styles.topMazesScreen.textColor;
    
    [self.averageRatingView setupWithStarColor: [UIColor redColor]
                                  outlineWidth: 1.0];
    
    [self.averageRatingView addToParentView: self.averageRatingContainerView];
    
    self.ratingCountLabel.textColor = self.styles.topMazesScreen.textColor;

    [self.userRatingView setupWithStarColor: [UIColor blueColor]
                               outlineWidth: 1.0];
    
    [self.userRatingView addToParentView: self.userRatingContainerView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(userRatingViewTapped:)];
    
    [self.userRatingContainerView addGestureRecognizer: tapGestureRecognizer];
    
    self.modifiedDateLabel.textColor = self.styles.topMazesScreen.textColor;
}

- (void)setupWithDelegate: (id<MATopWorldCollectionViewCellDelegate>)delegate
                    world: (MAWorld *)world
{
    _delegate = delegate;
    _world = world;
    
    self.nameLabel.text = self.world.name;
    
    [self.averageRatingView refreshWithRatingValue: world.averageRating];
    
    if (self.world.ratingCount == 0)
    {
        self.averageRatingView.hidden = YES;
        self.ratingCountLabel.text = @"";
    }
    else
    {
        self.averageRatingView.hidden = NO;
        self.ratingCountLabel.text = [NSString stringWithFormat: @"%d ratings", (int)self.world.ratingCount];
    }
    
    if ([self.world hasRatingWithUserRecordName: [MACurrentUser shared].recordname] == NO)
    {
        [self.userRatingView refreshWithRatingValue: 0.0];
    }
    else
    {
        float userRatingValue = [self.world ratingValueWithUserRecordName: [MACurrentUser shared].recordname];

        [self.userRatingView refreshWithRatingValue: userRatingValue];
    }
    
    /*
    if (self.mazeSummary1.userStarted == NO)
    {
        self.userRatingView.hidden = YES;
    }
    else
    {
        self.userRatingView.hidden = NO;
    }
    */
    
    self.modifiedDateLabel.text = self.world.modificationDateAsString;
}

- (void)userRatingViewTapped: (UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate topWorldCollectionViewCell: self
                         didTapUserRatingView: self.userRatingView
                                     forWorld: self.world];
}

@end






















