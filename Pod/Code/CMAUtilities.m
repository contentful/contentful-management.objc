//
//  CMAUtilities.m
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import <MapKit/MapKit.h>

NSDictionary* CMASanitizeParameterDictionaryForJSON(NSDictionary* fields) {
    NSMutableDictionary* mutableFields = [NSMutableDictionary dictionaryWithDictionary:fields];

    [mutableFields enumerateKeysAndObjectsUsingBlock:^(NSString* key,
                                                       NSDictionary* localizedValues, BOOL *stop) {
        NSMutableDictionary* mutableLocalizedValues = [localizedValues mutableCopy];

        [localizedValues enumerateKeysAndObjectsUsingBlock:^(NSString* locale, id value, BOOL *stop) {
            if ([value isKindOfClass:[NSData class]]) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
                [(NSData*)value getBytes:&coordinate length:sizeof(coordinate)];
                
                mutableLocalizedValues[locale] = @{ @"lon": @(coordinate.longitude),
                                                    @"lat": @(coordinate.latitude) };
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
