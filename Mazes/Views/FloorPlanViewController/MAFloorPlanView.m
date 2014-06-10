//
//  MAFloorPlanView.m
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MAFloorPlanView.h"

#import "MAFloorPlanStyle.h"
#import "MAFloorPlanViewDelegate.h"
#import "MALocation.h"
#import "MAMaze.h"
#import "MASize.h"
#import "MAStyles.h"
#import "MAUtilities.h"
#import "MAWall.h"

@interface MAFloorPlanView ()

@property (readonly, strong, nonatomic) MAStyles *styles;

@property (readonly, weak, nonatomic) id<MAFloorPlanViewDelegate> delegate;
@property (readonly, strong, nonatomic) MAMaze *maze;

@property (readwrite, strong, nonatomic) IBOutlet NSLayoutConstraint *widthLayoutConstraint;
@property (readwrite, strong, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;

@end

@implementation MAFloorPlanView

- (id)initWithCoder: (NSCoder *)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
        _styles = [MAStyles styles];

        _delegate = nil;
        _maze = nil;
    }
	
	return self;
}

- (CGSize)size
{
    return CGSizeMake(self.styles.floorPlan.segmentLengthShort * (self.maze.columns + 1) + self.styles.floorPlan.segmentLengthLong * self.maze.columns,
                      self.styles.floorPlan.segmentLengthShort * (self.maze.rows + 1) + self.styles.floorPlan.segmentLengthLong * self.maze.rows);
}

- (void)setupWithFloorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate
                                  maze: (MAMaze *)maze
{
    _delegate = floorPlanViewDelegate;
    _maze = maze;
}

- (void)didMoveToWindow
{
    self.backgroundColor = [UIColor clearColor];

    [super didMoveToWindow];
}

- (void)updateSizeConstraints
{
    self.widthLayoutConstraint.constant = self.size.width;
    self.heightLayoutConstraint.constant = self.size.height;
}

- (void)refreshUI
{
    [self setNeedsDisplay];
}

- (void)drawRect: (CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
   
	for (MALocation *location in [self.maze allLocations])
	{
        // location
		if (location.row <= self.maze.rows && location.column <= self.maze.columns)
		{
			CGRect locationRect = [self locationRectWithLocation: location];
			
			if (location.action == MALocationActionStart)
			{
				CGContextSetFillColorWithColor(context, self.styles.floorPlan.startColor.CGColor);
			}
			else if (location.action == MALocationActionEnd)
			{
				CGContextSetFillColorWithColor(context, self.styles.floorPlan.endColor.CGColor);
			}
			else if (location.action == MALocationActionStartOver)
			{
				CGContextSetFillColorWithColor(context, self.styles.floorPlan.startOverColor.CGColor);
			}
			else if (location.action == MALocationActionTeleport)
			{
				CGContextSetFillColorWithColor(context, self.styles.floorPlan.teleportationColor.CGColor);
			}
			else if ([location.message isEqualToString: @""] == NO)
			{
				CGContextSetFillColorWithColor(context, self.styles.floorPlan.messageColor.CGColor);
			}
			else if (location.action == MALocationActionDoNothing)
			{
				CGContextSetFillColorWithColor(context, self.styles.floorPlan.doNothingColor.CGColor);
			}
            else
            {
                [MAUtilities logWithClass: [self class]
                                  message: @"action set to an illegal value."
                               parameters: @{@"location.action" : @(location.action)}];
            }
			
			CGContextFillRect(context, locationRect);
			
			if (location.action == MALocationActionStart || location.action == MALocationActionTeleport)
			{
				[MAUtilities drawArrowInRect: locationRect
                                angleDegrees: location.direction
                                       scale: 0.8
                              floorPlanStyle: self.styles.floorPlan];
				
				if (location.action == MALocationActionTeleport)
				{
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.alignment = NSTextAlignmentCenter;
                    
                    NSAttributedString *teleportId = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", location.teleportId]
                                                                                     attributes: @{NSParagraphStyleAttributeName : paragraphStyle,
                                                                                                   NSFontAttributeName : self.styles.floorPlan.teleportFont,
                                                                                                   NSForegroundColorAttributeName : self.styles.floorPlan.teleportIdColor,
                                                                                                   }];
                    
                    [teleportId drawInRect: locationRect];
				}
			}
            
			if (location.floorTextureId != nil || location.ceilingTextureId != nil)
			{
				[MAUtilities drawBorderInsideRect: locationRect
                                        withWidth: self.styles.floorPlan.locationHighlightWidth
                                            color: self.styles.floorPlan.textureHighlightColor];
			}
            
			if (self.maze.currentSelectedLocation != nil)
			{
				if (location.row == self.maze.currentSelectedLocation.row &&
                    location.column == self.maze.currentSelectedLocation.column)
				{
					[MAUtilities drawBorderInsideRect: locationRect
                                            withWidth: self.styles.floorPlan.locationHighlightWidth
                                                color: self.styles.floorPlan.highlightColor];
				}
			}
		}
		
		// north wall
		if (location.column <= self.maze.columns)
		{
            MAWall *northWall = [self.maze wallWithRow: location.row
                                                column: location.column
                                             direction: MADirectionNorth];
            
			CGRect northWallRect = [self wallRectWithWall: northWall];

            switch (northWall.type)
            {
                case MAWallNone:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.noWallColor.CGColor);
                    break;
                    
                case MAWallBorder:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.borderWallColor.CGColor);
                    break;

                case MAWallSolid:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.solidColor.CGColor);
                    break;
                    
                case MAWallInvisible:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.invisibleColor.CGColor);
                    break;

                case MAWallFake:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.fakeColor.CGColor);
                    break;
                    
                default:
                    [MAUtilities logWithClass: [self class]
                                      message: @"Wall type set to an illegal value."
                                   parameters: @{@"northWall.type" : @(northWall.type)}];
                    break;
            }
            
            CGContextFillRect(context, northWallRect);
			
			if (northWall.textureId != nil)
			{
				[MAUtilities drawBorderInsideRect: northWallRect
                                        withWidth: self.styles.floorPlan.wallHighlightWidth
                                            color: self.styles.floorPlan.textureHighlightColor];
			}
            
			if (self.maze.currentSelectedWall != nil)
			{
				if (location.row == self.maze.currentSelectedWall.row &&
                    location.column == self.maze.currentSelectedWall.column &&
                    self.maze.currentSelectedWall.direction == MADirectionNorth)
				{
					[MAUtilities drawBorderInsideRect: northWallRect
                                            withWidth: self.styles.floorPlan.wallHighlightWidth
                                                color: self.styles.floorPlan.highlightColor];
				}
			}
		}
		
		// west wall
		if (location.row <= self.maze.rows)
		{
            MAWall *westWall = [self.maze wallWithRow: location.row
                                               column: location.column
                                            direction: MADirectionWest];

			CGRect westWallRect = [self wallRectWithWall: westWall];
            
            switch (westWall.type)
            {
                case MAWallNone:
					CGContextSetFillColorWithColor(context, self.styles.floorPlan.noWallColor.CGColor);
                    break;

                case MAWallBorder:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.borderWallColor.CGColor);
                    break;
                    
                case MAWallSolid:
                    CGContextSetFillColorWithColor(context, self.styles.floorPlan.solidColor.CGColor);
                    break;
                    
                case MAWallInvisible:
					CGContextSetFillColorWithColor(context, self.styles.floorPlan.invisibleColor.CGColor);
                    break;
                    
                case MAWallFake:
					CGContextSetFillColorWithColor(context, self.styles.floorPlan.fakeColor.CGColor);
                    break;
                    
                default:
                    [MAUtilities logWithClass: [self class]
                                      message: @"Wall type set to an illegal value."
                                   parameters: @{@"westWall.type" : @(westWall.type)}];
                    break;
            }

            CGContextFillRect(context, westWallRect);
            
			if (westWall.textureId != nil)
			{
				[MAUtilities drawBorderInsideRect: westWallRect
                                        withWidth: self.styles.floorPlan.wallHighlightWidth
                                            color: self.styles.floorPlan.textureHighlightColor];
			}
			
			if (self.maze.currentSelectedWall != nil)
			{
				if (location.row == self.maze.currentSelectedWall.row &&
                    location.column == self.maze.currentSelectedWall.column &&
                    self.maze.currentSelectedWall.direction == MADirectionWest)
				{
					[MAUtilities drawBorderInsideRect: westWallRect
                                            withWidth: self.styles.floorPlan.wallHighlightWidth
                                                color: self.styles.floorPlan.highlightColor];
				}
			}
		}
		
		// corner
		CGRect cornerRect = [self cornerRectWithLocation: location];
        
		if (location.row > 1 && location.row <= self.maze.rows &&
            location.column > 1 && location.column <= self.maze.columns)
		{
			CGContextSetFillColorWithColor(context, self.styles.floorPlan.cornerColor.CGColor);
			CGContextFillRect(context, cornerRect);
		}
		else
		{
			CGContextSetFillColorWithColor(context, self.styles.floorPlan.borderWallColor.CGColor);
			CGContextFillRect(context, cornerRect);
		}
	}
}

- (IBAction)handleTap: (UITapGestureRecognizer *)tapGestureRecognizer
{
    MAWall *wallSelected = nil;
 
    CGPoint touchPoint = [tapGestureRecognizer locationInView: self];
    
	float b = (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort) / 2.0;
	
	for (MAWall *someWall in [self.maze allWalls])
	{
        CGRect wallRect = [self wallRectWithWall: someWall];
        
        CGPoint wallOrigin = CGPointMake(wallRect.origin.x + wallRect.size.width / 2.0,
                                         wallRect.origin.y + wallRect.size.height / 2.0);
        
        float x = touchPoint.x - wallOrigin.x;
        float y = touchPoint.y - wallOrigin.y;
        
        if (((x >= -b && x <= 0) && (y >= -x - b && y <= x + b)) ||
            ((x >= 0 && x <= b) && (y >= x - b && y <= -x + b)))
        {
            wallSelected = someWall;
            break;
        }
	}
    
    if (wallSelected && self.delegate)
    {
        [self.delegate floorPlanView: self didSelectWall: wallSelected];
    }
}

- (IBAction)handleLongPress: (UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
        MALocation *locationSelected = nil;
        
        CGPoint touchPoint = [longPressGestureRecognizer locationInView: self];

        for (MALocation *someLocation in [self.maze allLocations])
        {
            CGRect locationRect = [self locationRectWithLocation: someLocation];
            
            CGRect touchRect = CGRectMake(locationRect.origin.x - self.styles.floorPlan.segmentLengthShort / 2.0,
                                          locationRect.origin.y - self.styles.floorPlan.segmentLengthShort / 2.0,
                                          self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort,
                                          self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort);
            
            if (CGRectContainsPoint(touchRect, touchPoint) &&
                someLocation.row <= self.maze.rows && someLocation.column <= self.maze.columns)
            {
                locationSelected = someLocation;
                break;
            }
        }
        
        if (locationSelected && self.delegate)
        {
            [self.delegate floorPlanView: self didSelectLocation: locationSelected];
        }
    }
}

- (CGRect)locationRectWithLocation: (MALocation *)location
{
    CGRect locationRect = CGRectMake(self.styles.floorPlan.segmentLengthShort + (location.column - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                                     self.styles.floorPlan.segmentLengthShort + (location.row - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                                     self.styles.floorPlan.segmentLengthLong,
                                     self.styles.floorPlan.segmentLengthLong);
    
	return locationRect;
}

- (CGRect)wallRectWithWall: (MAWall *)wall
{
    CGRect wallRect = CGRectZero;
    
    switch (wall.direction)
    {
        case MADirectionWest:
            wallRect = CGRectMake((wall.column - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
                                  self.styles.floorPlan.segmentLengthShort + (wall.row - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
                                  self.styles.floorPlan.segmentLengthShort,
                                  self.styles.floorPlan.segmentLengthLong);
            break;
            
        case MADirectionNorth:
            wallRect = CGRectMake(self.styles.floorPlan.segmentLengthShort + (wall.column - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
                                  (wall.row - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
                                  self.styles.floorPlan.segmentLengthLong,
                                  self.styles.floorPlan.segmentLengthShort);
            break;

        default:
            [MAUtilities logWithClass: [self class]
                              message: @"Wall direction set to an illegal value."
                           parameters: @{@"wall.direction" : @(wall.direction)}];
            break;
    }
    
    return wallRect;
}

- (CGRect)cornerRectWithLocation: (MALocation *)location
{
    CGRect cornerRect;
    
    cornerRect = CGRectMake((location.column - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                            (location.row - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                            self.styles.floorPlan.segmentLengthShort,
                            self.styles.floorPlan.segmentLengthShort);
            
	return cornerRect;
}

@end







