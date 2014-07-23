//
//  CMASpace.h
//  ManagementSDK
//
//  Created by Boris Bügling on 15/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMASpace : CDASpace

@property (nonatomic) NSString* name;

-(CDARequest*)updateWithSuccess:(void(^)())success failure:(CDARequestFailureBlock)failure;

@end
