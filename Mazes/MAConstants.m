//
//  MAConstants.m
//  Mazes
//
//  Created by Andre Muis on 7/29/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAConstants.h"

@implementation MAConstants

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _flurryAPIKey = @"72C58XPN2XTXVRTP27BN";
        _crittercismAppId = @"50cbd3ed4f633a03f0000003";
        
        _eventTimerIntervalSecs = 0.01;

        _localBaseSSLURL = [[NSURL alloc] initWithString: @"https://localhost:8443/mazes"];

        _remoteBaseSSLURL = [[NSURL alloc] initWithString: @"https://muis.fatfractal.com/mazes"];
        
        #ifdef DEBUG
        _baseSSLURL = _localBaseSSLURL;
        #else
        _baseSSLURL = _remoteBaseSSLURL;
        #endif

        _serverRetryDelaySecs = 5.0;
        
        _randomPasswordLength = 4;
        
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
        
        _greenTextureId = @"92A1B17C-5F19-4A6C-B70F-1C961A8A2FB5";
        _redTextureId = @"E774E067-D4D4-44D6-BC8D-6999B9FFA76E";
        
        _alternatingBrickTextureId = @"03C76469-321E-4D2D-A69C-D413670866CC";
        _lightSwirlMarbleTextureId = @"E4293FC5-74B5-460C-BD28-D71E1DB225E3";
        _creamyWhiteMarbleTextureId = @"91185953-544C-4D64-BEE5-F42F7778480E";
	}
	
    return self;
}

@end



















