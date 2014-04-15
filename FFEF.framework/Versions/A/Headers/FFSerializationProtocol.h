//
//  FFSerializationProtocol.h
//  FF-IOS-Framework
//
//  Created by Gary on 24/03/2014.
//
//

#import <Foundation/Foundation.h>

@protocol FFSerializationProtocol <NSObject>

@optional

/**
 Implement this method in a model class if you wish a property NOT to be serialized for saving to the server.
 <br>Note: You do not need to have your class formally implement the protocol; just implement the method
 either directly in, or in a category on, your class.
 */
- (BOOL) ff_shouldSerialize:(NSString *)propertyName;

/**
 Implement this method in a model class if you wish a property to be serialized as a set of references
 <br>Note: You do not need to have your class formally implement the protocol; just implement the method
 either directly in, or in a category on, your class.
 */
- (BOOL) ff_shouldSerializeAsSetOfReferences:(NSString *)propertyName;

@end
