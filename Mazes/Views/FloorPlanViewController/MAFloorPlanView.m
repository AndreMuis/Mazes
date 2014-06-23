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

@property (readwrite, strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (readwrite, strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (readwrite, strong, nonatomic) MALocation *previousSelectedLocation;
@property (readwrite, strong, nonatomic) MALocation *currentSelectedLocation;

@property (readwrite, strong, nonatomic) MAWall *currentSelectedWall;

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
        
        _widthLayoutConstraint = nil;
        _heightLayoutConstraint = nil;
        
        _previousSelectedLocation = nil;
        _currentSelectedLocation = nil;
        
        _currentSelectedWall = nil;
    }
    
    return self;
}

- (CGSize)size
{
    return CGSizeMake(self.styles.floorPlan.segmentLengthShort * (self.maze.columns + 1) + self.styles.floorPlan.segmentLengthLong * self.maze.columns,
                      self.styles.floorPlan.segmentLengthShort * (self.maze.rows + 1) + self.styles.floorPlan.segmentLengthLong * self.maze.rows);
}

static void *MAFloorPlanViewKVOContext = &MAFloorPlanViewKVOContext;

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary *)change
                       context: (void *)context
{
    if (context == MAFloorPlanViewKVOContext)
    {
        if (object == self.maze && ([keyPath isEqualToString: MAMazeRowsKeyPath] ||
                                    [keyPath isEqualToString: MAMazeColumnsKeyPath]))
        {
            [self updateSizeConstraints];
            [self setNeedsDisplay];
        }
        else if (object == self.maze && ([keyPath isEqualToString: MAMazeLocationsKeyPath]))
        {
            NSArray *oldLocations = change[@"old"];
            [self removeObserversFromLocations: oldLocations];
            
            NSArray *newLocations = change[@"new"];
            [self addObserversToLocations: newLocations];

            [self setNeedsDisplay];
        }
        else if (object == self.maze && ([keyPath isEqualToString: MAMazeWallsKeyPath]))
        {
            NSArray *oldWalls = change[@"old"];
            [self removeObserversFromWalls: oldWalls];
            
            NSArray *newWalls = change[@"new"];
            [self addObserversToWalls: newWalls];
            
            [self setNeedsDisplay];
        }
        else if ([object isMemberOfClass: [MALocation class]] && ([keyPath isEqualToString: MALocationActionKeyPath] ||
                                                                  [keyPath isEqualToString: MALocationDirectionKeyPath] ||
                                                                  [keyPath isEqualToString: MALocationFloorTextureIdKeyPath] ||
                                                                  [keyPath isEqualToString: MALocationCeilingTextureIdKeyPath]))
        {
            [self setNeedsDisplay];
        }
        else if ([object isMemberOfClass: [MAWall class]] && ([keyPath isEqualToString: MAWallTypeKeyPath] ||
                                                              [keyPath isEqualToString: MAWallTextureIdKeyPath]))
        {
            [self setNeedsDisplay];
        }
        else
        {
            [MAUtilities logWithClass: [self class]
                              message: @"Change of value for object's keyPath not handled."
                           parameters: @{@"keyPath" : keyPath,
                                         @"object" : object}];
        }
    }
    else
    {
        [super observeValueForKeyPath: keyPath
                             ofObject: object
                               change: change
                              context: context];
    }
}

- (void)setupWithDelegate: (id<MAFloorPlanViewDelegate>)delegate
                     maze: (MAMaze *)maze
{
    _delegate = delegate;
    _maze = maze;
    
    [self.maze addObserver: self
                forKeyPath: MAMazeRowsKeyPath
                   options: NSKeyValueObservingOptionNew
                   context: MAFloorPlanViewKVOContext];

    [self.maze addObserver: self
                forKeyPath: MAMazeColumnsKeyPath
                   options: NSKeyValueObservingOptionNew
                   context: MAFloorPlanViewKVOContext];

    [self.maze addObserver: self
                forKeyPath: MAMazeLocationsKeyPath
                   options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context: MAFloorPlanViewKVOContext];

    [self.maze addObserver: self
                forKeyPath: MAMazeWallsKeyPath
                   options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context: MAFloorPlanViewKVOContext];
    
    [self addObserversToLocations: self.maze.locations];
    [self addObserversToWalls: self.maze.walls];
    
    if (!self.delegate)
    {
        self.tapGestureRecognizer.enabled = NO;
        self.longPressGestureRecognizer.enabled = NO;
    }
}

- (void)addObserversToLocations: (NSArray *)locations
{
    for (MALocation *location in locations)
    {
        [location addObserver: self
                   forKeyPath: MALocationActionKeyPath
                      options: NSKeyValueObservingOptionNew
                      context: MAFloorPlanViewKVOContext];
        
        [location addObserver: self
                   forKeyPath: MALocationDirectionKeyPath
                      options: NSKeyValueObservingOptionNew
                      context: MAFloorPlanViewKVOContext];
        
        [location addObserver: self
                   forKeyPath: MALocationFloorTextureIdKeyPath
                      options: NSKeyValueObservingOptionNew
                      context: MAFloorPlanViewKVOContext];
        
        [location addObserver: self
                   forKeyPath: MALocationCeilingTextureIdKeyPath
                      options: NSKeyValueObservingOptionNew
                      context: MAFloorPlanViewKVOContext];
    }
}

- (void)removeObserversFromLocations: (NSArray *)locations
{
    for (MALocation *location in locations)
    {
        [location removeObserver: self
                      forKeyPath: MALocationActionKeyPath
                         context: MAFloorPlanViewKVOContext];
        
        [location removeObserver: self
                      forKeyPath: MALocationDirectionKeyPath
                         context: MAFloorPlanViewKVOContext];
        
        [location removeObserver: self
                      forKeyPath: MALocationFloorTextureIdKeyPath
                         context: MAFloorPlanViewKVOContext];
        
        [location removeObserver: self
                      forKeyPath: MALocationCeilingTextureIdKeyPath
                         context: MAFloorPlanViewKVOContext];
    }
}

- (void)addObserversToWalls: (NSArray *)walls
{
    for (MAWall *wall in walls)
    {
        [wall addObserver: self
               forKeyPath: MAWallTypeKeyPath
                  options: NSKeyValueObservingOptionNew
                  context: MAFloorPlanViewKVOContext];
        
        [wall addObserver: self
               forKeyPath: MAWallTextureIdKeyPath
                  options: NSKeyValueObservingOptionNew
                  context: MAFloorPlanViewKVOContext];
    }
}

- (void)removeObserversFromWalls: (NSArray *)walls
{
    for (MAWall *wall in walls)
    {
        [wall removeObserver: self
                  forKeyPath: MAWallTypeKeyPath
                     context: MAFloorPlanViewKVOContext];

        [wall removeObserver: self
                  forKeyPath: MAWallTextureIdKeyPath
                     context: MAFloorPlanViewKVOContext];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];

    self.backgroundColor = [UIColor clearColor];
}

- (void)updateSizeConstraints
{
    self.widthLayoutConstraint.constant = self.size.width;
    self.heightLayoutConstraint.constant = self.size.height;
}

- (void)drawRect: (CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    for (MALocation *location in [self.maze allLocations])
    {
        if (location.row <= self.maze.rows && location.column <= self.maze.columns)
        {
            CGRect locationFrame = [self frameForLocation: location];
            
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
            
            CGContextFillRect(context, locationFrame);
            
            if (location.action == MALocationActionStart || location.action == MALocationActionTeleport)
            {
                [MAUtilities drawArrowInRect: locationFrame
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
                    
                    [teleportId drawInRect: locationFrame];
                }
            }
            
            if (location.floorTextureId != nil || location.ceilingTextureId != nil)
            {
                [MAUtilities drawBorderInsideRect: locationFrame
                                        withWidth: self.styles.floorPlan.locationHighlightWidth
                                            color: self.styles.floorPlan.textureHighlightColor];
            }
            
            if (self.currentSelectedLocation != nil)
            {
                if (location.row == self.currentSelectedLocation.row &&
                    location.column == self.currentSelectedLocation.column)
                {
                    [MAUtilities drawBorderInsideRect: locationFrame
                                            withWidth: self.styles.floorPlan.locationHighlightWidth
                                                color: self.styles.floorPlan.highlightColor];
                }
            }
        }
        
        CGRect cornerFrame = [self cornerFrameWithLocation: location];
        
        if (location.row > 1 && location.row <= self.maze.rows &&
            location.column > 1 && location.column <= self.maze.columns)
        {
            CGContextSetFillColorWithColor(context, self.styles.floorPlan.cornerColor.CGColor);
            CGContextFillRect(context, cornerFrame);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.styles.floorPlan.borderWallColor.CGColor);
            CGContextFillRect(context, cornerFrame);
        }
    }
    
    for (MAWall *wall in [self.maze allWalls])
    {
        CGRect wallFrame = [self frameForWall: wall];

        switch (wall.type)
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
                               parameters: @{@"wall.type" : @(wall.type)}];
                break;
        }
        
        CGContextFillRect(context, wallFrame);
        
        if (wall.textureId != nil)
        {
            [MAUtilities drawBorderInsideRect: wallFrame
                                    withWidth: self.styles.floorPlan.wallHighlightWidth
                                        color: self.styles.floorPlan.textureHighlightColor];
        }
        
        if (self.currentSelectedWall != nil)
        {
            if (wall.row == self.currentSelectedWall.row &&
                wall.column == self.currentSelectedWall.column &&
                wall.direction == self.currentSelectedWall.direction)
            {
                [MAUtilities drawBorderInsideRect: wallFrame
                                        withWidth: self.styles.floorPlan.wallHighlightWidth
                                            color: self.styles.floorPlan.highlightColor];
            }
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
        CGRect wallFrame = [self frameForWall: someWall];
        
        CGPoint wallOrigin = CGPointMake(wallFrame.origin.x + wallFrame.size.width / 2.0,
                                         wallFrame.origin.y + wallFrame.size.height / 2.0);
        
        float x = touchPoint.x - wallOrigin.x;
        float y = touchPoint.y - wallOrigin.y;
        
        if (((x >= -b && x <= 0) && (y >= -x - b && y <= x + b)) ||
            ((x >= 0 && x <= b) && (y >= x - b && y <= -x + b)))
        {
            wallSelected = someWall;
            break;
        }
    }
    
    if (wallSelected && [self.maze isInnerWall: wallSelected])
    {
        self.currentSelectedWall = wallSelected;
        
        [self setNeedsDisplay];

        if (self.delegate)
        {
            [self.delegate floorPlanView: self didSelectInnerWall: wallSelected];
        }
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
            CGRect locationFrame = [self frameForLocation: someLocation];
            
            CGRect touchRect = CGRectMake(locationFrame.origin.x - self.styles.floorPlan.segmentLengthShort / 2.0,
                                          locationFrame.origin.y - self.styles.floorPlan.segmentLengthShort / 2.0,
                                          self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort,
                                          self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort);
            
            if (CGRectContainsPoint(touchRect, touchPoint) &&
                someLocation.row <= self.maze.rows && someLocation.column <= self.maze.columns)
            {
                locationSelected = someLocation;
                break;
            }
        }
        
        if (locationSelected)
        {
            self.previousSelectedLocation = self.currentSelectedLocation;
            self.currentSelectedLocation = locationSelected;
            
            [self setNeedsDisplay];
            
            if (self.delegate)
            {
                [self.delegate floorPlanView: self didSelectLocation: locationSelected];
            }
        }
    }
}

- (CGRect)frameForLocation: (MALocation *)location
{
    CGRect frame = CGRectMake(self.styles.floorPlan.segmentLengthShort + (location.column - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                              self.styles.floorPlan.segmentLengthShort + (location.row - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                              self.styles.floorPlan.segmentLengthLong,
                              self.styles.floorPlan.segmentLengthLong);
    
    return frame;
}

- (CGRect)frameForWall: (MAWall *)wall
{
    CGRect frame = CGRectZero;
    
    switch (wall.direction)
    {
        case MADirectionWest:
            frame = CGRectMake((wall.column - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
                               self.styles.floorPlan.segmentLengthShort + (wall.row - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
                               self.styles.floorPlan.segmentLengthShort,
                               self.styles.floorPlan.segmentLengthLong);
            break;
            
        case MADirectionNorth:
            frame = CGRectMake(self.styles.floorPlan.segmentLengthShort + (wall.column - 1) * (self.styles.floorPlan.segmentLengthShort + self.styles.floorPlan.segmentLengthLong),
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
    
    return frame;
}

- (CGRect)cornerFrameWithLocation: (MALocation *)location
{
    CGRect frame;
    
    frame = CGRectMake((location.column - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                       (location.row - 1) * (self.styles.floorPlan.segmentLengthLong + self.styles.floorPlan.segmentLengthShort),
                       self.styles.floorPlan.segmentLengthShort,
                       self.styles.floorPlan.segmentLengthShort);
            
    return frame;
}

@end







