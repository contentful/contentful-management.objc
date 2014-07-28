//
//  CMAEntry.h
//  Pods
//
//  Created by Boris Bügling on 25/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAEntry : CDAEntry

-(CDARequest *)archiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest*)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest*)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(void)setValue:(id)value forFieldWithName:(NSString *)key;
-(CDARequest *)unarchiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest *)unpublishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest*)updateWithSuccess:(void(^)())success failure:(CDARequestFailureBlock)failure;

@end
