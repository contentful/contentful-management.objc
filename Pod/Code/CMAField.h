//
//  CMAField.h
//  Pods
//
//  Created by Boris Bügling on 29/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAField : CDAField

+(instancetype)fieldWithName:(NSString*)name type:(CDAFieldType)type;

@end
