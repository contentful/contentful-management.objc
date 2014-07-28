//
//  CMAPublishing.h
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <Foundation/Foundation.h>

@protocol CMAPublishing

-(CDARequest *)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest *)unpublishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
