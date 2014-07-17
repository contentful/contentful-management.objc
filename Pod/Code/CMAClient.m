//
//  CMAClient.m
//  ManagementSDK
//
//  Created by Boris Bügling on 14/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>

#import "CDAClient+Private.h"
#import "CMAClient.h"

@interface CMAClient ()

@property (nonatomic) CDAClient* client;

@end

#pragma mark -

@implementation CMAClient

-(CDARequest *)fetchAllSpacesWithSuccess:(CDAArrayFetchedBlock)success
                                 failure:(CDARequestFailureBlock)failure {
    return [self.client fetchArrayAtURLPath:@"spaces"
                                 parameters:@{}
                                    success:success
                                    failure:failure];
}

-(CDARequest *)fetchSpaceWithIdentifier:(NSString *)identifier
                                success:(CMASpaceFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    return [self.client fetchURLPath:[@"spaces/" stringByAppendingString:identifier]
                          parameters:@{}
                             success:success
                             failure:failure];
}

-(id)initWithAccessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        CDAConfiguration* configuration = [CDAConfiguration defaultConfiguration];
        configuration.server = @"api.contentful.com";
        self.client = [[CDAClient alloc] initWithSpaceKey:nil
                                              accessToken:accessToken
                                            configuration:configuration];
        self.client.resourceClassPrefix = @"CMA";
    }
    return self;
}

@end
