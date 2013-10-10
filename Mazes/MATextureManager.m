//
//  MATextureManager.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATextureManager.h"

#import "MATexture.h"
#import "MAUtilities.h"

@interface  MATextureManager ()

@property (strong, nonatomic, readonly) AMFatFractal *amFatFractal;
@property (strong, nonatomic) AMRequest *amRequest;
@property (strong, nonatomic, readonly) NSArray *textures;

@end

@implementation MATextureManager

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal
{
    self = [super init];
	
	if (self)
	{
        _amFatFractal = amFatFractal;
        _amRequest = nil;
        _textures = nil;
	}
	
    return self;
}

- (void)downloadWithCompletionHandler: (TexturesDownloadCompletionHandler)handler
{
    self.amRequest = [self.amFatFractal amGetArrayFromURI: @"/MATexture"
                                        completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            _textures = (NSArray *)theObj;
            handler();
        }
        else
        {
             [MAUtilities logWithClass: [self class]
                                format: @"Unable to get textures from server. StatusCode: %d. Error: %@", theResponse.statusCode, theErr];
        }
    }];
}

- (void)cancelDownload
{
    [self.amFatFractal amCancelRequest: self.amRequest];
}

- (NSArray *)all
{
	return self.textures;
}

- (NSArray *)sortedByKindThenOrder
{
    NSSortDescriptor *kindSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"kind" ascending: YES];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];

    NSArray *sortedArray = [self.textures sortedArrayUsingDescriptors: [NSArray arrayWithObjects: kindSortDescriptor, orderSortDescriptor, nil]];

    return sortedArray;
}

- (MATexture *)textureWithTextureId: (NSString *)textureId
{
    MATexture *texture = nil;
    
    NSUInteger index = [self.textures indexOfObjectPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL *stop)
                        {
                            return [((MATexture *)obj).textureId isEqualToString: textureId];
                        }];
    
    if (index != NSNotFound)
    {
        texture = [self.textures objectAtIndex: index];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Unable to find texture with textureId: %d", textureId];
    }
    
    return texture;
}

- (NSString *)description 
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"textures = %@>", self.textures];
    
    return desc;
}

@end













