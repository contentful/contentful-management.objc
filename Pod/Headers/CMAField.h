//
//  CMAField.h
//  Pods
//
//  Created by Boris Bügling on 29/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

/**
 *  Management extensions for fields.
 */
@interface CMAField : CDAField

/**
 *  Create a new field, locally. This API should be used to create fields for creating and updating
 *  content types.
 *
 *  @param name The name of the new field.
 *  @param type The type of the new field.
 *
 *  @return A new field instance.
 */
+(instancetype)fieldWithName:(NSString*)name type:(CDAFieldType)type;

@end
