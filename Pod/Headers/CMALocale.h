//
//  CMALocale.h
//  Pods
//
//  Created by Boris Bügling on 08/08/14.
//
//

#import "CDAResource.h"

/**
 *  Models the localization of a space into one specific language.
 */
@interface CMALocale : CDAResource

/**
 *  The country-code of the receiver.
 */
@property (nonatomic) NSString* code;

/**
 *  The name of the receiver.
 */
@property (nonatomic) NSString* name;

@end
