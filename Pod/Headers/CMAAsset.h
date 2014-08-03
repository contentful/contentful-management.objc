//
//  CMAAsset.h
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

/**
 *  Management extensions for assets.
 */
@interface CMAAsset : CDAAsset <CMAArchiving, CMAPublishing, CMAResource>

/**
 *  The title of the receiver.
 */
@property (nonatomic) NSString* title;

/**
 *  Initiate processing of the uploaded file of the receiver.
 *
 *  Processing is required to publish an asset. This call will only initiate the processing, it is
 *  not finished when it is completed, because processing happens completely asynchronous.
 *
 *  @param success Called if processing is successfully initiated.
 *  @param failure Called if processing could not be initiated.
 *
 *  @return The request for initiating processing.
 */
-(CDARequest*)processWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure;

@end
