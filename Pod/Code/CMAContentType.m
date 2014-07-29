//
//  CMAContentType.m
//  Pods
//
//  Created by Boris Bügling on 24/07/14.
//
//

#import "CDAClient+Private.h"
#import "CDAResource+Private.h"
#import "CMAContentType.h"

@interface CMAContentType ()

@property (nonatomic, readonly) NSString* URLPath;

@end

#pragma mark -

@implementation CMAContentType

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"" withSuccess:success failure:failure];
}

-(CDARequest*)performDeleteToFragment:(NSString*)fragment
                          withSuccess:(void (^)())success
                              failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client deleteURLPath:[self.URLPath stringByAppendingPathComponent:fragment]
                              headers:nil
                           parameters:nil
                              success:^(CDAResponse *response, CMAEntry* entry) {
                                  [self updateWithResource:entry];

                                  if (success) {
                                      success();
                                  }
                              } failure:failure];
}

-(NSString *)URLPath {
    return [@"content_types" stringByAppendingPathComponent:self.identifier];
}

@end
