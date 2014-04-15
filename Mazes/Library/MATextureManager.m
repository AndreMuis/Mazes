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

@property (strong, nonatomic, readonly) Reachability *reachability;
@property (strong, nonatomic, readonly) MAWebServices *webServices;

@property (strong, nonatomic, readonly) NSArray *textures;

@property (assign, nonatomic, readwrite) NSUInteger count;

@property (strong, nonatomic, readonly) UIAlertView *downloadErrorAlertView;

@end

@implementation MATextureManager

+ (MATextureManager *)textureManagerWithReachability: (Reachability *)reachability
                                         webServices: (MAWebServices *)webServices
{
    MATextureManager *textureManager = [[MATextureManager alloc] initWithWithReachability: reachability
                                                                              webServices: webServices];
    return textureManager;
}

- (id)initWithWithReachability: (Reachability *)reachability
                   webServices: (MAWebServices *)webServices
{
    self = [super init];
	
	if (self)
	{
        _reachability = reachability;
        _webServices = webServices;
        
        _textures = [NSArray array];
        
        _count = 0;
        
        _downloadErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                             message: MARequestErrorMessage
                                                            delegate: self
                                                   cancelButtonTitle: @"Cancel"
                                                   otherButtonTitles: @"Retry", nil];
	}
	
    return self;
}

- (void)downloadTextures
{
    [self.webServices getTexturesWithCompletionHandler: ^(NSArray *textures, NSError *error)
     {
         if (error == nil)
         {
             _textures = textures;
             
             self.count = self.textures.count;
         }
         else
         {
             [self.downloadErrorAlertView show];
         }
     }];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView == self.downloadErrorAlertView && buttonIndex == 1)
    {
        [self downloadTextures];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: [NSString stringWithFormat: @"AlertView not handled. AlertView: %@", alertView]];
    }
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













