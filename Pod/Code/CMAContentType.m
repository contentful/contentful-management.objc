//
//  CMAContentType.m
//  Pods
//
//  Created by Boris Bügling on 24/07/14.
//
//

#import "CDAResource+Management.h"
#import "CMAContentType.h"

@interface CMAContentType ()

@property (nonatomic, readonly) NSString* URLPath;

@end

#pragma mark -

@implementation CMAContentType

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"" withSuccess:success failure:failure];
}

-(CDARequest *)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"published" withSuccess:success failure:failure];
}

-(CDARequest *)unpublishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"published" withSuccess:^{
        // Delay is needed to avoid issues with deleted Content Types still showing up in search.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           if (success) {
                               success();
                           }
                       });
    } failure:failure];
}

-(NSString *)URLPath {
    return [@"content_types" stringByAppendingPathComponent:self.identifier];
}

@end
