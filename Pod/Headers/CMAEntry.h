//
//  CMAEntry.h
//  Pods
//
//  Created by Boris Bügling on 25/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAEntry : CDAEntry <CMAArchiving, CMAPublishing, CMAResource>

-(void)setValue:(id)value forFieldWithName:(NSString *)key;

@end
