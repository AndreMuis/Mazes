//
//  Constants.m
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (Constants *)shared
{
	static Constants *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Constants alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _flurryAPIKey = @"72C58XPN2XTXVRTP27BN";
        
        _crittercismAppId = @"50cbd3ed4f633a03f0000003";
        
        self.eventTimerIntervalSecs = 0.01;
        
        #if TARGET_IPHONE_SIMULATOR
        _serverBaseURL = [[NSURL alloc] initWithString: @"http://localhost:3000"];
        #else
        _serverBaseURL = [[NSURL alloc] initWithString: @"http://173.45.249.212:3000"];
        #endif

        _serverRetryDelaySecs = 5.0;
        
        _receiveResponseTimeoutSecs = 5.0;

		_rowsMin = 3;
		_rowsMax = 15;
		_columnsMin = _rowsMin;
		_columnsMax = _rowsMax;
		
		_wallHeight = 1.0;
		_eyeHeight = 0.6 * _wallHeight;
		_wallWidth = 1.2;
		_wallDepth = 0.2;
		
        _textureCount = 1000;
        
		_movementDuration = 0.4;
		_stepDurationAvgStart = 1 / 60.0;
		_fakeMovementPrcnt = 0.2; // percent of movement before wall disappears
		
		_locationMessageMaxLength = 250;
		_mazeNameMaxLength = 50;
		_nameExists = -1;
	}
	
    return self;
}

@end



















