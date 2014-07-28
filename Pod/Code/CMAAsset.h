//
//  CMAAsset.h
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAAsset : CDAAsset <CMAArchiving, CMAPublishing, CMAResource>

@property (nonatomic) NSString* title;

-(CDARequest*)processWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
