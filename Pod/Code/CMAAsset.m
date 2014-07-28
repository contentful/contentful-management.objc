//
//  CMAAsset.m
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import "CMAAsset.h"
#import "CDAClient+Private.h"
#import "CDAResource+Private.h"

@interface CMAAsset ()

@property (nonatomic, readonly) NSString* URLPath;

@end

#pragma mark -

@implementation CMAAsset

-(CDARequest *)archiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"archived" withSuccess:success failure:failure];
}

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client deleteURLPath:self.URLPath
                              headers:nil
                           parameters:nil
                              success:^(CDAResponse *response, id responseObject) {
                                  if (success) {
                                      success();
                                  }
                              } failure:failure];
}

-(CDARequest*)performDeleteToFragment:(NSString*)fragment
                          withSuccess:(void (^)())success
                              failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client deleteURLPath:[self.URLPath stringByAppendingPathComponent:fragment]
                              headers:nil
                           parameters:nil
                              success:^(CDAResponse *response, CMAAsset* asset) {
                                  [self updateWithResource:asset];

                                  if (success) {
                                      success();
                                  }
                              } failure:failure];
}

-(CDARequest*)performPutToFragment:(NSString*)fragment
                       withSuccess:(void (^)())success
                           failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[self.URLPath stringByAppendingPathComponent:fragment]
                           headers:@{ @"X-Contentful-Version": [self.sys[@"version"] stringValue] }
                        parameters:nil
                           success:^(CDAResponse *response, CMAAsset* asset) {
                               [self updateWithResource:asset];

                               if (success) {
                                   success();
                               }
                           } failure:failure];
}

-(CDARequest *)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"published" withSuccess:success failure:failure];
}

-(CDARequest *)unarchiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"archived" withSuccess:success failure:failure];
}

-(NSString *)URLPath {
    return [@"assets" stringByAppendingPathComponent:self.identifier];
}

@end
