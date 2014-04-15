//
//  FFReadResponse.h
//  FF-IOS-Framework
//
//  Created by Gary on 03/11/2013.
//
//

#import <Foundation/Foundation.h>

@class FFReadRequest;

@interface FFReadResponse : NSObject

/** \brief Designated initializer */
- initWithRequest:(FFReadRequest *)request;

/** \brief The request to which this is the response */
@property (strong, nonatomic, readonly) FFReadRequest *request;

/** \brief The actual NSHTTPURLResponse which was received */
@property (strong, nonatomic) NSHTTPURLResponse *httpResponse;
/** \brief The raw response data */
@property (strong, nonatomic) NSData *rawResponseData;
/** \brief Error status */
@property (strong, nonatomic) NSError *error;

/** \brief Did the response come from the cache? */
@property (nonatomic) BOOL responseCameFromCache;

/** \brief The statusMessage from the backend, if available */
@property (strong, nonatomic) NSString *statusMessage;

/** \brief If you're expecting an array of zero or more objects, call this */
@property (strong, nonatomic) NSArray *objs;

/** \brief Is a null response OK?
 @see #obj
 */
@property (nonatomic) BOOL nullResponseAllowed;

/** \brief If you're expecting at most one object, call this.
 <br>If more than one object was returned from the backend, then nil is returned, and an error status is set
 <br>If no object was returned from the backend, then an error status is set
 <strong><em>unless</em></strong> you have set #nullResponseAllowed to YES
 @see #nullResponseAllowed
 */
@property (strong, nonatomic) id obj;

@end
