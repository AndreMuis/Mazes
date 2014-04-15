//
//  FFReadRequest.h
//  FF-IOS-Framework
//
//  Created by Gary on 03/11/2013.
//
//

#import <Foundation/Foundation.h>

@class FFReadResponse;
@class FatFractal;

typedef void (^FFReadRequestCompletion)
(
 FFReadResponse *response
 );

/** \file FFReadRequest.h */

/**
 Values for readOptions bitmasks for #executeAsyncWithOptions:andBlock:  and #executeSyncWithOptions:
 <ul>
 <li><b>FFReadOptionAutoLoadRefs<b>        When retrieving objects, automatically retrieve objects which they reference</li>
 <li><b>FFReadOptionAutoLoadBlobs<b>       When retrieving objects, automatically retrieve any BLOBs they contain</li>
 <li><b>FFReadOptionCacheResponse<b>       When retrieving, cache the response</li>
 <li><b>FFReadOptionUseCachedOnly<b>       When retrieving, ONLY try the cache - i.e. do not hit the network</li>
 <li><b>FFReadOptionUseCachedIfCached<b>   When retrieving, try the cache first - only hit the network if cache is empty</li>
 <li><b>FFReadOptionUseCachedIfOffline<b>  When retrieving, try the network first - if offline, then try the cache</li>
 </ul>
 @see FFReadRequest::executeAsyncWithOptions:andBlock:
 @see FFReadRequest::executeSyncWithOptions:
 */
typedef NS_OPTIONS(NSInteger,FFReadOption) {
    FFReadOptionAutoLoadRefs        = (0x1 << 0),
    FFReadOptionAutoLoadBlobs       = (0x1 << 1),
    FFReadOptionCacheResponse       = (0x1 << 2),
    FFReadOptionUseCachedOnly       = (0x1 << 3),
    FFReadOptionUseCachedIfCached   = (0x1 << 4),
    FFReadOptionUseCachedIfOffline  = (0x1 << 5)
};


@interface FFReadRequest : NSObject

/** \brief The FatFractal instance with which this read request was created */
@property (strong, nonatomic, readonly)           FatFractal *ff;

/** \brief The options being used by this request */
@property (nonatomic, readonly)         FFReadOption options;

/**
 \brief Set a queryName when you have a query which needs to be cached where it is logically the same query every time,
 but the exact query text will be different.
 */
@property (strong, nonatomic)           NSString *queryName;

/** \brief error status */
@property (strong, nonatomic, readonly) NSError *error;

/** \brief Has the request been sent? */
@property (nonatomic, readonly)           BOOL sent;

/** \brief the url to which this request will be or has been sent */
@property (strong, nonatomic, readonly)   NSURL *url;

/** \brief Prepare a GET from ANY URL */
- prepareGetFromURL:(NSURL *)url;

/** \brief Prepare a GET from a FatFractal URI, relative to the Base URL of your application
 @see FatFractal::getArrayFromUri:onComplete:
 */
- prepareGetFromUri:(NSString *)uri;

/** \brief Prepare a GET from a collection (eg /Comments ) in your FatFractal application
 @see FatFractal::getArrayFromUri:onComplete:
 */
- prepareGetFromCollection:(NSString *)collectionUri;

/** \brief Prepare a GET from an extension (eg /getLatestModificationDates ) in your FatFractal application
 @see FatFractal::getArrayFromExtension:onComplete:
 */
- prepareGetFromExtension:(NSString *)extensionUri;

/** \brief Prepare a GrabBag request - get all items in a given GrabBag
 @see FatFractal::grabBagGetAllForObj:grabBagName:onComplete:
 */
- prepareGrabBagGetAllForObj:(id)parentObj grabBagName:(NSString *)gbName;

/** \brief Prepare a GrabBag request - get all items in a given GrabBag which match the query
 @see FatFractal::grabBagGetAllForObj:grabBagName:withQuery:onComplete:
 */
- prepareGrabBagGetAllForObj:(id)parentObj grabBagName:(NSString *)gbName withQuery:(NSString *)query;

/** \brief Executes the request using default options; will execute the completion block when the request is complete */
 - (void) executeAsyncWithBlock:(FFReadRequestCompletion)block;

/** \brief Executes the request, with the specified options. Will execute the completion block when the request is complete */
 - (void) executeAsyncWithOptions:(FFReadOption)options andBlock:(FFReadRequestCompletion)block;
 
/** \brief Executes the request synchronously, using default options. Useful when you are not on the main thread. */
 - (FFReadResponse *) executeSync;

/** \brief Executes the request synchronously, with the specified options. Useful when you are not on the main thread. */
 - (FFReadResponse *) executeSyncWithOptions:(FFReadOption)options;

/** \brief What do this request's options specify for autoLoadRefs */
- (BOOL) autoLoadRefs;

/** \brief What do this request's options specify for autoLoadBlobs */
- (BOOL) autoLoadBlobs;

/** \brief What do this request's options specify for shouldCacheResponse */
- (BOOL) shouldCacheResponse;

/** \brief What do this request's options specify for useCachedOnly */
- (BOOL) useCachedOnly;

/** \brief What do this request's options specify for useCachedIfOffline */
- (BOOL) useCachedIfOffline;

/** \brief What do this request's options specify for useCachedIfCached */
- (BOOL) useCachedIfCached;

/** \brief Designated initializer. Called by FatFractal::newReadRequest */
- initWithFf:(FatFractal *)ff;

@end
