//
//  CMAContentType.h
//  Pods
//
//  Created by Boris Bügling on 24/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@class CMAField;

/**
 *  Management extension for content types.
 */
@interface CMAContentType : CDAContentType <CMAPublishing, CMAResource>

-(BOOL)addFieldWithName:(NSString*)name type:(CDAFieldType)type;
-(void)deleteField:(CMAField*)field;
-(void)deleteFieldWithIdentifier:(NSString*)identifier;

@end
