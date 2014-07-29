//
//  CMAOrganization.h
//  Pods
//
//  Created by Boris Bügling on 29/07/14.
//
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

@interface CMAOrganization : CDAResource

@property (nonatomic, readonly, getter = isActive) BOOL active;
@property (nonatomic, readonly) NSString* name;

@end
