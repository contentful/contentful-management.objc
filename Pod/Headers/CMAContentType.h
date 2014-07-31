//
//  CMAContentType.h
//  Pods
//
//  Created by Boris Bügling on 24/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

/**
 *  Management extension for content types.
 */
@interface CMAContentType : CDAContentType <CMAPublishing>

/**
 *  Delete the receiver.
 *
 *  A content type needs to be unpublished to be deletable.
 *
 *  @param success Called if deletion succeeds.
 *  @param failure Called if deletion fails.
 *
 *  @return The request used for deletion.
 */
-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
