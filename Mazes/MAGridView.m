//
//  MAGridView.m
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MAGridView.h"

#import "MACanvasStyle.h"
#import "MALocation.h"
#import "MASize.h"
#import "MAStyles.h"
#import "MAUtilities.h"
#import "MAWall.h"

@implementation MAGridView

- (id)initWithCoder: (NSCoder *)coder 
{    
    self = [super initWithCoder: coder];
    
    if (self) 
	{
        _maze = nil;
        _styles = nil;
    }
	
	return self;
}

- (void)didMoveToWindow
{
    self.backgroundColor = self.styles.canvas.backgroundColor;
    
    [super didMoveToWindow];
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
				CGContextSetFillColorWithColor(context, self.styles.canvas.startColor.CGColor);
			}
			else if (location.action == MALocationActionEnd)
			{
				CGContextSetFillColorWithColor(context, self.styles.canvas.endColor.CGColor);
			}
			else if (location.action == MALocationActionStartOver)
			{
				CGContextSetFillColorWithColor(context, self.styles.canvas.startOverColor.CGColor);
			}
			else if (location.action == MALocationActionTeleport)
			{
				CGContextSetFillColorWithColor(context, self.styles.canvas.teleportationColor.CGColor);
			}
			else if ([location.message isEqualToString: @""] == NO)
			{
				CGContextSetFillColorWithColor(context, self.styles.canvas.messageColor.CGColor);
			}
			else if (location.action == MALocationActionDoNothing)
			{
				CGContextSetFillColorWithColor(context, self.styles.canvas.doNothingColor.CGColor);
			}
            else
            {
                [MAUtilities logWithClass: [self class] format: @"action set to an illegal value: %d", location.action];
            }
			
			CGContextFillRect(context, locationRect);
			
			if (location.action == MALocationActionStart || location.action == MALocationActionTeleport)
			{
				[MAUtilities drawArrowInRect: locationRect angleDegrees: location.direction scale: 0.8 canvasStyle: self.styles.canvas];
				
				if (location.action == MALocationActionTeleport)
				{
					CGContextSetFillColorWithColor(context, self.styles.canvas.teleportIdColor.CGColor);
                    
					NSString *num = [NSString stringWithFormat: @"%d", location.teleportId];
                    
                    NSDictionary *attribues = @{NSFontAttributeName : [UIFont systemFontOfSize: self.styles.canvas.teleportFontSize]};
                    
                    [num drawInRect: locationRect
                     withAttributes: attribues];
				}
			}
            
			if (location.floorTextureId != nil || location.ceilingTextureId != nil)
			{
				[MAUtilities drawBorderInsideRect: locationRect
                                        withWidth: self.styles.canvas.textureHighlightWidth
                                            color: self.styles.canvas.textureHighlightColor];
			}
            
			if (self.maze.currentSelectedLocation != nil)
			{
				if (location.row == self.maze.currentSelectedLocation.row &&
                    location.column == self.maze.currentSelectedLocation.column)
				{
					[MAUtilities drawBorderInsideRect: locationRect
                                            withWidth: self.styles.canvas.locationHighlightWidth
                                                color: self.styles.canvas.locationHighlightColor];
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
                    CGContextSetFillColorWithColor(context, self.styles.canvas.noWallColor.CGColor);
                    break;
                    
                case MAWallBorder:
                    CGContextSetFillColorWithColor(context, self.styles.canvas.borderColor.CGColor);
                    break;

                case MAWallSolid:
                    CGContextSetFillColorWithColor(context, self.styles.canvas.solidColor.CGColor);
                    break;
                    
                case MAWallInvisible:
                    CGContextSetFillColorWithColor(context, self.styles.canvas.invisibleColor.CGColor);
                    break;

                case MAWallFake:
                    CGContextSetFillColorWithColor(context, self.styles.canvas.fakeColor.CGColor);
                    break;
                    
                default:
                    [MAUtilities logWithClass: [self class] format: @"Wall type set to an illegal value: %d", northWall.type];
                    break;
            }
            
            CGContextFillRect(context, northWallRect);
			
			if (northWall.textureId != nil)
			{
				[MAUtilities drawBorderInsideRect: northWallRect
                                        withWidth: self.styles.canvas.textureHighlightWidth
                                            color: self.styles.canvas.textureHighlightColor];
			}
            
			if (self.maze.currentSelectedWall != nil)
			{
				if (location.row == self.maze.currentSelectedWall.row &&
                    location.column == self.maze.currentSelectedWall.column &&
                    self.maze.currentSelectedWall.direction == MADirectionNorth)
				{
					[MAUtilities drawBorderInsideRect: northWallRect
                                            withWidth: self.styles.canvas.wallHighlightWidth
                                                color: self.styles.canvas.locationHighlightColor];
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
					CGContextSetFillColorWithColor(context, self.styles.canvas.noWallColor.CGColor);
                    break;

                case MAWallBorder:
                    CGContextSetFillColorWithColor(context, self.styles.canvas.borderColor.CGColor);
                    break;
                    
                case MAWallSolid:
                    CGContextSetFillColorWithColor(context, self.styles.canvas.solidColor.CGColor);
                    break;
                    
                case MAWallInvisible:
					CGContextSetFillColorWithColor(context, self.styles.canvas.invisibleColor.CGColor);
                    break;
                    
                case MAWallFake:
					CGContextSetFillColorWithColor(context, self.styles.canvas.fakeColor.CGColor);
                    break;
                    
                default:
                    [MAUtilities logWithClass: [self class] format: @"Wall type set to an illegal value: %d", westWall.type];
                    break;
            }

            CGContextFillRect(context, westWallRect);
            
			if (westWall.textureId != nil)
			{
				[MAUtilities drawBorderInsideRect: westWallRect
                                        withWidth: self.styles.canvas.textureHighlightWidth
                                            color: self.styles.canvas.textureHighlightColor];
			}
			
			if (self.maze.currentSelectedWall != nil)
			{
				if (location.row == self.maze.currentSelectedWall.row &&
                    location.column == self.maze.currentSelectedWall.column &&
                    self.maze.currentSelectedWall.direction == MADirectionWest)
				{
					[MAUtilities drawBorderInsideRect: westWallRect
                                            withWidth: self.styles.canvas.wallHighlightWidth
                                                color: self.styles.canvas.locationHighlightColor];
				}
			}
		}
		
		// corner
		CGRect cornerRect = [self cornerRectWithLocation: location];
        
		if (location.row > 1 && location.row <= self.maze.rows &&
            location.column > 1 && location.column <= self.maze.columns)
		{
			CGContextSetFillColorWithColor(context, self.styles.canvas.cornerColor.CGColor);
			CGContextFillRect(context, cornerRect);
		}
		else
		{
			CGContextSetFillColorWithColor(context, self.styles.canvas.borderColor.CGColor);
			CGContextFillRect(context, cornerRect);
		}
	}
}

- (void)refresh
{
    [self setNeedsDisplay];
}

- (MALocation *)locationWithTouchPoint: (CGPoint)touchPoint
{
	MALocation *locationRet = nil;
	
	for (MALocation *location in [self.maze allLocations])
	{
		CGRect locationRect = [self locationRectWithLocation: location];
        
		CGRect touchRect = CGRectMake(locationRect.origin.x - self.styles.canvas.segmentLengthShort / 2.0,
                                      locationRect.origin.y - self.styles.canvas.segmentLengthShort / 2.0,
                                      self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort,
                                      self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort);
		
		if (CGRectContainsPoint(touchRect, touchPoint) &&
            location.row <= self.maze.rows && location.column <= self.maze.columns)
		{
			locationRet = location;
			break;
		}
	}
    
	return locationRet;
}

- (MAWall *)wallWithTouchPoint: (CGPoint)touchPoint
{
	CGRect wallRect = CGRectZero;
	CGPoint wallOrigin = CGPointZero;
	
	float tx = 0.0, ty = 0.0;
	float b = (self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort) / 2.0;
	
	for (MAWall *wall in [self.maze allWalls])
	{
        wallRect = [self wallRectWithWall: wall];
			
        wallOrigin.x = wallRect.origin.x + wallRect.size.width / 2.0;
        wallOrigin.y = wallRect.origin.y + wallRect.size.height / 2.0;
        
        tx = touchPoint.x - wallOrigin.x;
        ty = touchPoint.y - wallOrigin.y;
        
        BOOL found = NO;
        if (tx >= -b && tx <= 0)
        {
            if (ty >= -tx - b && ty <= tx + b)
            {
                found = YES;
            }
        }
        else if (tx >= 0 && tx <= b)
        {
            if (ty >= tx - b && ty <= -tx + b)
            {
                found = YES;
            }
        }
        
        if (found == YES)
        {
            if ((wall.column <= self.maze.columns && wall.row <= self.maze.rows) ||
                (wall.column == self.maze.columns + 1 && wall.type == MADirectionWest && wall.row <= self.maze.rows) ||
                (wall.row == self.maze.rows + 1 && wall.type == MADirectionNorth && wall.column <= self.maze.columns))
            {
                return wall;
            }
        }
	}
    
	return nil;
}

- (CGRect)locationRectWithLocation: (MALocation *)location
{
    CGRect locationRect = CGRectMake(self.styles.canvas.segmentLengthShort + (location.column - 1) * (self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort),
                                     self.styles.canvas.segmentLengthShort + (location.row - 1) * (self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort),
                                     self.styles.canvas.segmentLengthLong,
                                     self.styles.canvas.segmentLengthLong);
    
	return locationRect;
}

- (CGRect)wallRectWithWall: (MAWall *)wall
{
    CGRect wallRect;
    
    switch (wall.direction)
    {
        case MADirectionWest:
            wallRect = CGRectMake((wall.column - 1) * (self.styles.canvas.segmentLengthShort + self.styles.canvas.segmentLengthLong),
                                  self.styles.canvas.segmentLengthShort + (wall.row - 1) * (self.styles.canvas.segmentLengthShort + self.styles.canvas.segmentLengthLong),
                                  self.styles.canvas.segmentLengthShort,
                                  self.styles.canvas.segmentLengthLong);
            break;
            
        case MADirectionNorth:
            wallRect = CGRectMake(self.styles.canvas.segmentLengthShort + (wall.column - 1) * (self.styles.canvas.segmentLengthShort + self.styles.canvas.segmentLengthLong),
                                  (wall.row - 1) * (self.styles.canvas.segmentLengthShort + self.styles.canvas.segmentLengthLong),
                                  self.styles.canvas.segmentLengthLong,
                                  self.styles.canvas.segmentLengthShort);
            break;

        default:
            [MAUtilities logWithClass: [self class] format: @"Wall direction set to an illegal value: %d", wall.direction];
            
            break;
    }
    
    return wallRect;
}

- (CGRect)cornerRectWithLocation: (MALocation *)location
{
    CGRect cornerRect;
    
    cornerRect = CGRectMake((location.column - 1) * (self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort),
                            (location.row - 1) * (self.styles.canvas.segmentLengthLong + self.styles.canvas.segmentLengthShort),
                            self.styles.canvas.segmentLengthShort,
                            self.styles.canvas.segmentLengthShort);
            
	return cornerRect;
}

@end

























