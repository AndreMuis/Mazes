//
//  MASoundManager.m
//  Mazes
//
//  Created by Andre Muis on 2/22/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MASoundManager.h"

#import "MAGameViewController.h"
#import "MASound.h"
#import "MAUtilities.h"

@interface MASoundManager ()

@property (strong, nonatomic, readonly) AMFatFractal *amFatFractal;
@property (strong, nonatomic, readonly) AMRequest *amRequest;
@property (strong, nonatomic, readonly) NSArray *sounds;

@end

@implementation MASoundManager

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal
{
    self = [super init];
	
	if (self)
	{
        _amFatFractal = amFatFractal;
        _amRequest = nil;
        _sounds = nil;
	}
	
    return self;
}

- (int)count
{
    return self.sounds.count;
}

- (void)downloadWithCompletionHandler: (SoundsDownloadCompletionHandler)handler
{
    _amRequest = [self.amFatFractal amGetArrayFromURI: @"/MASound"
                                    completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            _sounds = (NSArray *)theObj;

            for (MASound *sound in self.sounds)
            {
                [sound setup];
            }
          
            handler();
        }
        else
        {
            [MAUtilities logWithClass: [self class]
                               format: @"Unable to get sounds from server. StatusCode: %d. Error: %@", theResponse.statusCode, theErr];
        }
    }];
}

- (void)cancelDownload
{
    [self.amFatFractal amCancelRequest: self.amRequest];
}

- (NSArray *)sortedByName
{
    NSArray *sortedArray = [self.sounds sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2)
    {
        NSString *name1 = ((MASound *)obj1).name;
        NSString *name2 = ((MASound *)obj2).name;
        
        return [name1 compare: name2];
    }];
    
    return sortedArray;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"sounds = %@>", self.sounds];

    return desc;
}

@end























