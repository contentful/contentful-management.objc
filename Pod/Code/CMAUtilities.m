//
//  CMAUtilities.m
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>
#import <MapKit/MapKit.h>

#import "CDAResource+Management.h"

static NSDateFormatter* dateFormatter = nil;

NSDictionary* CMASanitizeParameterDictionaryForJSON(NSDictionary* fields) {
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        NSLocale *posixLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:posixLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }

    NSMutableDictionary* mutableFields = [NSMutableDictionary dictionaryWithDictionary:fields];

    [mutableFields enumerateKeysAndObjectsUsingBlock:^(NSString* key,
                                                       NSDictionary* localizedValues, BOOL *stop) {
        NSMutableDictionary* mutableLocalizedValues = [localizedValues mutableCopy];

        [localizedValues enumerateKeysAndObjectsUsingBlock:^(NSString* locale, id value, BOOL *stop) {
            if ([value isKindOfClass:[CDAResource class]]) {
                mutableLocalizedValues[locale] = [(CDAResource*)value linkDictionary];
            }

            if ([value isKindOfClass:[NSData class]]) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
                [(NSData*)value getBytes:&coordinate length:sizeof(coordinate)];
                
                mutableLocalizedValues[locale] = @{ @"lon": @(coordinate.longitude),
                                                    @"lat": @(coordinate.latitude) };
            }

            if ([value isKindOfClass:[NSDate class]]) {
                mutableLocalizedValues[locale] = [dateFormatter stringFromDate:(NSDate*)value];
            }
        }];

        mutableFields[key] = [mutableLocalizedValues copy];
    }];

    return mutableFields.count == 0 ? @{} : [mutableFields copy];
}

NSDictionary* CMATransformLocalizedFieldsToParameterDictionary(NSDictionary* localizedFields) {
    NSMutableDictionary* result = [@{} mutableCopy];

    [localizedFields enumerateKeysAndObjectsUsingBlock:^(NSString* language, NSDictionary* values,
                                                         BOOL *stop) {
        [values enumerateKeysAndObjectsUsingBlock:^(NSString* fieldName, id value, BOOL *stop) {
            NSMutableDictionary* fieldValues = result[fieldName] ?: [@{} mutableCopy];
            fieldValues[language] = value;
            result[fieldName] = fieldValues;
        }];
    }];

    return CMASanitizeParameterDictionaryForJSON(result);
}
