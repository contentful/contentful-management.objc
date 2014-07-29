//
//  CMAContentType.h
//  Pods
//
//  Created by Boris Bügling on 24/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAContentType : CDAContentType

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
