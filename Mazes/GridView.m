//
//  GridView.m
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "GridView.h"

#import "GridStyle.h"
#import "Locations.h"
#import "Location.h"
#import "Maze.h"
#import "Styles.h"
#import "Utilities.h"

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
    
	for (Location *location in self.maze.locations.list)
	{
        // Locations
        
		if (location.x <= self.maze.columns && location.y <= self.maze.rows)
		{
			segmentRect = [self.maze.locations getSegmentRectFromLocation: location segmentType: MAMazeObjectLocation];
			
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
                [Utilities logWithClass: [self class] format: @"action set to an illegal value: %d", location.action];
            }
			
			CGContextFillRect(context, segmentRect);
			
			if (location.action == MALocationActionStart || location.action == MALocationActionTeleport)
			{
				[Utilities drawArrowInRect: segmentRect angleDegrees: location.direction scale: 0.8];
				
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
			
			if (location.floorTextureId != 0 || location.ceilingTextureId != 0)
			{
				[Utilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}
            
			if (self.currentLocation != nil)
			{
				if (location.x == self.currentLocation.x && location.y == self.currentLocation.y)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.locationHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Wall North
		
		if (location.x <= self.maze.columns)
		{
			segmentRect = [self.maze.locations getSegmentRectFromLocation: location segmentType: MAMazeObjectWallNorth];
            
            MAWallType wallType = [self.maze.locations getWallTypeLocX: location.x locY: location.y direction: MADirectionNorth];
            
            switch (wallType)
            {
                case MAWallNone:
                    CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                    break;
                    
                case MAWallSolid:
                    if (location.y == 1 || location.y == self.maze.rows + 1)
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
                    [Utilities logWithClass: [self class] format: @"Wall type set to an illegal value: %d", wallType];
                    break;
            }
            
            CGContextFillRect(context, segmentRect);
			
			if (location.wallNorthTextureId != 0)
			{
				[Utilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}
            
			if (self.currentWallLocation != nil)
			{
				if (location.x == self.currentWallLocation.x && location.y == self.currentWallLocation.y && self.currentWallDirection == MADirectionNorth)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Wall West
		
		if (location.y <= self.maze.rows)
		{
			segmentRect = [self.maze.locations getSegmentRectFromLocation: location segmentType: MAMazeObjectWallWest];
            
            MAWallType wallType = [self.maze.locations getWallTypeLocX: location.x locY: location.y direction: MADirectionWest];            
            
            switch (wallType)
            {
                case MAWallNone:
					CGContextSetFillColorWithColor(context, [Styles shared].grid.noWallColor.CGColor);
                    break;
                    
                case MAWallSolid:
                    if (location.x == 1 || location.x == self.maze.columns + 1)
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
                    [Utilities logWithClass: [self class] format: @"Wall type set to an illegal value: %d", wallType];
                    break;
            }

            CGContextFillRect(context, segmentRect);
            
			if (location.wallNorthTextureId != 0)
			{
				[Utilities drawBorderInsideRect: segmentRect
                                      withWidth: [Styles shared].grid.textureHighlightWidth
                                          color: [Styles shared].grid.textureHighlightColor];
			}
			
			if (self.currentWallLocation != nil)
			{
				if (location.x == self.currentWallLocation.x && location.y == self.currentWallLocation.y && self.currentWallDirection == MADirectionWest)
				{
					[Utilities drawBorderInsideRect: segmentRect
                                          withWidth: [Styles shared].grid.wallHighlightWidth
                                              color: [Styles shared].grid.locationHighlightColor];
				}
			}
		}
		
		// Corner
        
		segmentRect = [self.maze.locations getSegmentRectFromLocation: location segmentType: MAMazeObjectCorner];
        
		if (location.y > 1 && location.y <= self.maze.rows && location.x > 1 && location.x <= self.maze.columns)
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
