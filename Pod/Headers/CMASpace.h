//
//  CMASpace.h
//  ManagementSDK
//
//  Created by Boris Bügling on 15/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@class CMAContentType;

/**
 *  Management extensions for spaces.
 */
@interface CMASpace : CDASpace <CMAResource>

/**
 *  The name of the receiver.
 */
@property (nonatomic) NSString* name;

/**
 *  Create a new asset on Contentful.
 *
 *  @param fields  The field values for the new asset.
 *  @param success Called if creation succeeds.
 *  @param failure Called if creation fails.
 *
 *  @return The request used for creation.
 */
-(CDARequest*)createAssetWithFields:(NSDictionary*)fields
                            success:(CMAAssetFetchedBlock)success
                            failure:(CDARequestFailureBlock)failure;

/**
 *  Create a new content type on Contentful.
 *
 *  @param name    The name for the new content type.
 *  @param fields  The fields for the new content type.
 *  @param success Called if creation succeeds.
 *  @param failure Called if creation fails.
 *
 *  @return The request used for creation.
 */
-(CDARequest*)createContentTypeWithName:(NSString*)name
                                 fields:(NSArray*)fields
                                success:(CMAContentTypeFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure;

/**
 *  Create a new entry on Contentful.
 *
 *  @param contentType The content type for the new entry.
 *  @param fields      The field values for the new entry.
 *  @param success     Called if creation succeeds.
 *  @param failure     Called if creation fails.
 *
 *  @return The request used for creation.
 */
-(CDARequest*)createEntryOfContentType:(CMAContentType*)contentType
                            withFields:(NSDictionary*)fields
                               success:(CMAEntryFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;

/**
 *  Fetch a single asset from Contentful.
 *
 *  @param identifier The identifier of the asset to fetch.
 *  @param success    Called if fetching succeeds.
 *  @param failure    Called if fetching fails.
 *
 *  @return The request used for fetching data.
 */
-(CDARequest*)fetchAssetWithIdentifier:(NSString*)identifier
                               success:(CMAAssetFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;

/**
 *  Fetch all content types from Contentful.
 *
 *  @param success Called if fetching succeeds.
 *  @param failure Called if fetching fails.
 *
 *  @return The request used for fetching data.
 */
-(CDARequest*)fetchContentTypesWithSuccess:(CDAArrayFetchedBlock)success
                                   failure:(CDARequestFailureBlock)failure;

/**
 *  Fetch a single content type from Contentful.
 *
 *  @param identifier The identifier of the content type to fetch.
 *  @param success    Called if fetching succeeds.
 *  @param failure    Called if fetching fails.
 *
 *  @return The request used for fetching data.
 */
-(CDARequest*)fetchContentTypeWithIdentifier:(NSString*)identifier
                                     success:(CMAContentTypeFetchedBlock)success
                                     failure:(CDARequestFailureBlock)failure;

/**
 *  Fetch a single entry from Contentful.
 *
 *  @param identifier The identifier of the entry to fetch.
 *  @param success    Called if fetching succeeds.
 *  @param failure    Called if fetching fails.
 *
 *  @return The request used for fetching data.
 */
-(CDARequest*)fetchEntryWithIdentifier:(NSString*)identifier
                               success:(CDAEntryFetchedBlock)success
                               failure:(CDARequestFailureBlock)failure;

@end
