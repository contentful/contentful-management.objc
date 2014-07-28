//
//  CMAEntry.h
//  Pods
//
//  Created by Boris Bügling on 25/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAEntry : CDAEntry

-(CDARequest*)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(void)setValue:(id)value forFieldWithName:(NSString *)key;
-(CDARequest*)updateWithSuccess:(void(^)())success failure:(CDARequestFailureBlock)failure;

@end
