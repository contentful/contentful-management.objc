//
//  CMAClient.h
//  contentful-management.objc
//
//  Created by Boris Bügling on 14/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "CDAClient.h"

@interface CMAClient : NSObject

-(id)initWithAccessToken:(NSString*)accessToken;

-(CDARequest*)fetchAllSpacesWithSuccess:(CDAArrayFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure;

@end
