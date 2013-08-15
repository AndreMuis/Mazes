//
//  GridView.m
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "GridView.h"

#import "GridStyle.h"
#import "MALocation.h"
#import "MAMaze.h"
#import "MAUtilities.h"
#import "Styles.h"

@implementation GridView

- (id)initWithCoder: (NSCoder *)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
        _maze = nil;
        _currentLocation = nil;
        _currentWallLocation = nil;
        _currentWallDirection = MADirectionUnknown;
        
		self.backgroundColor = [Styles shared].grid.backgroundColor;
    }
	
	return self;
}

- (void)drawRect: (CGRect)rect 
{
	CGRect segmentRect;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	for (MALocation *location in self.maze.locations)
	{
        // Locations
        
		if (location.xx <= self.maze.columns && location.yy <= self.maze.rows)
		{
			segmentRect = [self.maze segmentRectWithLocation: location segmentType: MAMazeObjectLocation];
			
			if (location.action == MALocationActionStart)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.startColor.CGColor);
			}
			else if (location.action == MALocationActionEnd)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.endColor.CGColor);
			}
			else if (location.action == MALocationActionStartOver)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.startOverColor.CGColor);
			}
			else if (location.action == MALocationActionTeleport)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.teleportationColor.CGColor);
			}
			else if ([location.message isEqualToString: @""] == NO)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.messageColor.CGColor);
			}
			else if (location.action == MALocationActionDoNothing)
			{
				CGContextSetFillColorWithColor(context, [Styles shared].grid.doNothingColor.CGColor);
			}
            else
            {
                [MAUtilities logWithClass: [self class] format: @"action set to an illegal value: %d", location.action];
            }
			
			CGContextFillRect(context, segmentRect);
			
			if (location.action == MALocationActionStart || location.action == MALocationActionTeleport)
			{
				[MAUtilities drawArrowInRect: segmentRect angleDegrees: location.direction scale: 0.8];
				
				if (location.action == MALocationActionTeleport)
				{
					CGContextSetFillColorWithColor(context, [Styles shared].grid.teleportIdColor.CGColor);
                    
					NSString *num = [NSString stringWithFormat: @"%d", location.teleportId];
                    
					[num drawInRect: segmentRect
                           withFont: [UIFont systemFontOfSize: [Styles shared].grid.teleportFontSize]
                      lineBreakMode: NSLineBreakByClipping
                          alignment: NSTextAlignmentCenter];
				}
			}
			
			if (location.floorTexture != nil || location.ceilingTexture != nil)
			{
				[MAUtilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}
            
			if (self.currentLocation != nil)
			{
				if (location.xx == self.currentLocation.xx && location.yy == self.currentLocation.yy)
				{
					[MAUtilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.locationHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Wall North
		
		if (location.xx <= self.maze.columns)
		{
			segmentRect = [self.maze segmentRectWithLocation: location segmentType: MAMazeObjectWallNorth];
            
            MAWallType wallType = [self.maze wallTypeWithLocationX: location.xx
                                                         locationY: location.yy
                                                         direction: MADirectionNorth];
            
            switch (wallType)
            {
                case MAWallNone:
                    CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                    break;
                    
                case MAWallSolid:
                    if (location.yy == 1 || location.yy == self.maze.rows + 1)
                    {
                        CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
                    }
                    else
                    {
                        CGContextSetFillColorWithColor(context, [Styles shared].grid.solidColor.CGColor);
                    }
                    break;
                    
                case MAWallInvisible:
                    CGContextSetFillColorWithColor(context, [Styles shared].grid.invisibleColor.CGColor);
                    break;

                case MAWallFake:
                    CGContextSetFillColorWithColor(context, [Styles shared].grid.fakeColor.CGColor);
                    break;
                    
                default:
                    [MAUtilities logWithClass: [self class] format: @"Wall type set to an illegal value: %d", wallType];
                    break;
            }
            
            CGContextFillRect(context, segmentRect);
			
			if (location.wallNorthTexture != nil)
			{
				[MAUtilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}
            
			if (self.currentWallLocation != nil)
			{
				if (location.xx == self.currentWallLocation.xx && location.yy == self.currentWallLocation.yy && self.currentWallDirection == MADirectionNorth)
				{
					[MAUtilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Wall West
		
		if (location.yy <= self.maze.rows)
		{
			segmentRect = [self.maze segmentRectWithLocation: location segmentType: MAMazeObjectWallWest];
            
            MAWallType wallType = [self.maze wallTypeWithLocationX: location.xx
                                                         locationY: location.yy
                                                         direction: MADirectionWest];
            
            switch (wallType)
            {
                case MAWallNone:
					CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                    break;
                    
                case MAWallSolid:
                    if (location.xx == 1 || location.xx == self.maze.columns + 1)
                    {
                        CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
                    }
                    else
                    {
                        CGContextSetFillColorWithColor(context, [Styles shared].grid.solidColor.CGColor);                    
                    }
                    break;
                    
                case MAWallInvisible:
					CGContextSetFillColorWithColor(context, [Styles shared].grid.invisibleColor.CGColor);
                    break;
                    
                case MAWallFake:
					CGContextSetFillColorWithColor(context, [Styles shared].grid.fakeColor.CGColor);
                    break;
                    
                default:
                    [MAUtilities logWithClass: [self class] format: @"Wall type set to an illegal value: %d", wallType];
                    break;
            }

            CGContextFillRect(context, segmentRect);
            
			if (location.wallNorthTexture != nil)
			{
				[MAUtilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}
			
			if (self.currentWallLocation != nil)
			{
				if (location.xx == self.currentWallLocation.xx && location.yy == self.currentWallLocation.yy && self.currentWallDirection == MADirectionWest)
				{
					[MAUtilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Corner
        
		segmentRect = [self.maze segmentRectWithLocation: location segmentType: MAMazeObjectCorner];
        
		if (location.yy > 1 && location.yy <= self.maze.rows && location.xx > 1 && location.xx <= self.maze.columns)
		{
			CGContextSetFillColorWithColor(context, [Styles shared].grid.cornerColor.CGColor);
			CGContextFillRect(context, segmentRect);
		}
		else
		{
			CGContextSetFillColorWithColor(context, [Styles shared].grid.borderColor.CGColor);
			CGContextFillRect(context, segmentRect);
		}
	}
}

@end  
