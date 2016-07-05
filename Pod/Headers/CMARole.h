//
//  CMARole.h
//  Pods
//
//  Created by Boris Bügling on 05/07/16.
//

#import <ContentfulDeliveryAPI/CDANullabilityStubs.h>
#import <ContentfulDeliveryAPI/CDAResource.h>

NS_ASSUME_NONNULL_BEGIN

/** Role of a Space. */
@interface CMARole : CDAResource

/** Name of the role */
@property (nonatomic, copy, readonly) NSString* name;

/** The permissions of the role */
@property (nonatomic, copy, readonly) NSDictionary* permissions;

/** The policies of the role */
@property (nonatomic, copy, readonly) NSArray* policies;

/** Description of the role */
@property (nonatomic, copy, readonly) NSString* roleDescription;

@end

NS_ASSUME_NONNULL_END
