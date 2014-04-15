//
//  FFUtils.h
//  FatFractal
//
//  Copyright (c) 2012, 2013 FatFractal, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

/*! \brief A set of utility methods used by the FatFractal Emergent Framework for iOS. */
/*! 
 This class provides a set of utility methods used by the FatFractal Emergent Framework for iOS
 */ 
@interface FFUtils : NSObject

/*!
 The 'real' class of this object. Because Core Data.
 @param obj the object
 @return Class the class of the object, which it gets by NSClassFromString(obj.entity.name) if a NSManagedObject, otherwise it's simply the class
 */

+ (Class) realClassForObj:(id)obj;

/*!
 The set of properties for this Object (including its superclasses up to NSObject).
 The set of properties is cached.
 @param obj the object
 @return NSDictionary a dictionary with the properties
 */
+ (NSDictionary *) propertiesForObj:(id)obj;

/*!
 The set of properties for this Class (including its superclasses up to NSObject).
 The set of properties is cached.
 @param class the class
 @return NSDictionary a dictionary with the properties
 */
//+ (NSDictionary *) propertiesForClass:(Class)class;

/*!
 Check equality by checking the properties of the objects for equality using key-value-coding.
 @param o1 object 1
 @param o2 object 2
 @param reason an out parameter which, if the objects are not equal, contains the reason why
 @return BOOL true if the properties are equal, false otherwise
 */
+ (BOOL) object:(id)o1 hasEqualValuesTo:(id)o2 notEqualReason:(NSString **)reason;

/*!
 Utility method for adding error messages to <b>NSError</b>
 @param NSString msg the message to be returned with the error.
 @return <b>NSError</b> errorWithDomain:@"FatFractal" code:1 userInfo: NSDictionary errorDetail
 @return <b>NSError error</b> is nil if no error. In the event of an error, <b>NSError error</b> is set using
 <b>createErrorWithLocalizedDescription</b> with an error message.
 */
+ (NSError *) createErrorWithLocalizedDescription:(NSString *)msg;

/*!
 Same as #createErrorWithLocalizedDescription:, but also lets the response code be set.
 @param NSString msg the message to be returned with the error.
 @param NSInteger code the code to set for the error.
 @return <b>NSError</b> errorWithDomain:@"FatFractal" code:1 userInfo: NSDictionary errorDetail
 @return <b>NSError error</b> is nil if no error. In the event of an error, <b>NSError error</b> is set using
 */
+ (NSError *) createErrorWithLocalizedDescription:(NSString *)msg code:(NSInteger)code;

/*!
 Convert an NSDate to an ISO string a la 2014-01-31T13:01:02.999Z
 */
+ (NSString *) isoUTCStringFromDate:(NSDate *)date;

/*!
 Convert an NSDate to a Unix timestamp - i.e. number of milliseconds since Jan 1 1970
 */
+ (NSNumber *) unixTimeStampFromDate:(NSDate *)date;

@end

