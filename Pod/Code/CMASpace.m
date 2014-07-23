//
//  CMASpace.m
//  ManagementSDK
//
//  Created by Boris Bügling on 15/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "CDAClient+Private.h"
#import "CDARequestOperationManager.h"
#import "CDAResource+Private.h"
#import "CMASpace.h"

@implementation CMASpace

@dynamic name;

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    NSDictionary* headers = @{ @"X-Contentful-Version": [self.sys[@"version"] stringValue] };
    NSString* URLPath = [@"spaces" stringByAppendingPathComponent:self.identifier];

    return [self.client.requestOperationManager putURLPath:URLPath
                                                   headers:headers
                                                parameters:@{ @"name": self.name }
                                                   success:^(CDAResponse *response, CMASpace* space) {
                                                       [self updateWithResource:space];

                                                       if (success) success();
                                                   } failure:failure];
}

@end
