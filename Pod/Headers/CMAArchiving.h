//
//  CMAArchiving.h
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <Foundation/Foundation.h>

@protocol CMAArchiving

-(CDARequest *)archiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;
-(CDARequest *)unarchiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
