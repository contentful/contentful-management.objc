//
//  CMAUtilities.m
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

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

    return [result copy];
}
