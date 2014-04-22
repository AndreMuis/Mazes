//
//  MATextureManager.m
//  Mazes
//
//  Created by Andre Muis on 2/12/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import "MATextureManager.h"

#import "MAConstants.h"
#import "MATexture.h"
#import "MAUtilities.h"
#import "MAWebServices.h"

@interface  MATextureManager ()

@property (strong, nonatomic, readonly) MAWebServices *webServices;

@property (strong, nonatomic, readonly) NSArray *textures;

@property (assign, nonatomic, readwrite) NSUInteger count;

@end

@implementation MATextureManager

+ (MATextureManager *)textureManagerWithWebServices: (MAWebServices *)webServices
{
    MATextureManager *textureManager = [[MATextureManager alloc] initWithWithWebServices: webServices];
    return textureManager;
}

- (id)initWithWithWebServices: (MAWebServices *)webServices
{
    self = [super init];
	
	if (self)
	{
        _webServices = webServices;
        
        _textures = [NSArray array];
        
        _count = 0;
	}
	
    return self;
}

- (void)downloadTexturesWithCompletionHandler: (DownloadTexturesCompletionHandler)handler
{
    [self.webServices getTexturesWithCompletionHandler: ^(NSArray *textures, NSError *error)
     {
         if (error == nil)
         {
             _textures = textures;
             
             self.count = self.textures.count;
             
             handler(nil);
         }
         else
         {
             handler(error);
         }
     }];
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













