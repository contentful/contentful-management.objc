//
//  CMAClient.h
//  ManagementSDK
//
//  Created by Boris Bügling on 14/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>

@class CMAAsset;
@class CMAContentType;
@class CMAEntry;
@class CMAOrganization;
@class CMASpace;

typedef void(^CMAAssetFetchedBlock)(CDAResponse* response, CMAAsset* asset);
typedef void(^CMAContentTypeFetchedBlock)(CDAResponse* response, CMAContentType* contentType);
typedef void(^CMAEntryFetchedBlock)(CDAResponse* response, CMAEntry* entry);
typedef void(^CMASpaceFetchedBlock)(CDAResponse* response, CMASpace* space);

@interface CMAClient : NSObject

-(id)initWithAccessToken:(NSString*)accessToken;

-(CDARequest*)createSpaceWithName:(NSString*)name
                          success:(CMASpaceFetchedBlock)success
                          failure:(CDARequestFailureBlock)failure;

-(CDARequest*)createSpaceWithName:(NSString*)name
                   inOrganization:(CMAOrganization*)organization
                          success:(CMASpaceFetchedBlock)success
                          failure:(CDARequestFailureBlock)failure;

-(CDARequest*)fetchAllSpacesWithSuccess:(CDAArrayFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure;

-(CDARequest*)fetchOrganizationsWithSuccess:(CDAArrayFetchedBlock)success
                                    failure:(CDARequestFailureBlock)failure;

-(CDARequest*)fetchSpaceWithIdentifier:(NSString*)identifier
                               success:(CMASpaceFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;

@end
