//
//  CMASpace.h
//  ManagementSDK
//
//  Created by Boris Bügling on 15/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@class CMAContentType;

@interface CMASpace : CDASpace

@property (nonatomic) NSString* name;

-(CDARequest*)createAssetWithFields:(NSDictionary*)fields
                            success:(CMAAssetFetchedBlock)success
                            failure:(CDARequestFailureBlock)failure;
-(CDARequest*)createEntryOfContentType:(CMAContentType*)contentType
                            withFields:(NSDictionary*)fields
                               success:(CMAEntryFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;
-(CDARequest*)fetchAssetWithIdentifier:(NSString*)identifier
                               success:(CMAAssetFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;
-(CDARequest*)fetchContentTypesWithSuccess:(CDAArrayFetchedBlock)success
                                   failure:(CDARequestFailureBlock)failure;
-(CDARequest*)fetchEntryWithIdentifier:(NSString*)identifier
                               success:(CDAEntryFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;
-(CDARequest*)updateWithSuccess:(void(^)())success failure:(CDARequestFailureBlock)failure;

@end
