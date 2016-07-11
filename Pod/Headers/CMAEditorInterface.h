//
//  CMAEditorInterface.h
//  Pods
//
//  Created by Boris Bügling on 11/07/16.
//
//

#import <ContentfulDeliveryAPI/CDANullabilityStubs.h>
#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

NS_ASSUME_NONNULL_BEGIN

/** Editor interface for a content type. */
@interface CMAEditorInterface : CDAResource

/** Array of controls */
@property (nonatomic, copy, readonly) NSArray* controls;

@end

NS_ASSUME_NONNULL_END
