//
//  CMAResource.h
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <Foundation/Foundation.h>

@protocol CMAResource

-(CDARequest*)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest*)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
