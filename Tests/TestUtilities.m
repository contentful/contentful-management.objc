//
//  TestUtilities.m
//  ManagementSDK
//
//  Created by Boris Bügling on 05/03/15.
//  Copyright (c) 2015 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "CMAUtilities.h"

void _itTestForSanitize(id self, int lineNumber, const char *fileName, NSString *name,
                        NSDictionary* fields) {
    it(name, ^{
        NSDictionary* sanitized = CMASanitizeParameterDictionaryForJSON(fields);

        __block NSError* error = nil;
        __block NSData* result = nil;

        expect(^{ result = [NSJSONSerialization dataWithJSONObject:sanitized
                                                           options:0
                                                             error:&error]; }).toNot.raiseAny();

        expect(result).toNot.beNil();
        expect(error).to.beNil();
    });
}

SpecBegin(Utilities)

describe(@"CMASanitizeParameterDictionaryForJSON", ^{
    _itTestForSanitize(self, __LINE__, __FILE__, @"sanitizes date values",
                       @{ @"en-US": @{ @"someDate": [NSDate new] } });
});

SpecEnd
