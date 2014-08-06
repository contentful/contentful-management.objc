//
//  CMAField.m
//  Pods
//
//  Created by Boris Bügling on 29/07/14.
//
//

#import "CDAField+Private.h"
#import "CMAField.h"

@interface CDAField ()

-(void)setIdentifier:(NSString*)identifier;
-(void)setName:(NSString*)name;
-(void)setType:(CDAFieldType)type;

@end

#pragma mark -

@implementation CMAField

+(instancetype)fieldWithName:(NSString *)name type:(CDAFieldType)type {
    CMAField* field = [[self alloc] initWithDictionary:@{ @"type": @"Symbol" }
                                                client:(CDAClient*)[NSNull null]];
    field.identifier = [self identifierFromString:name];
    field.name = name;
    field.type = type;
    return field;
}

+(NSString*)identifierFromString:(NSString*)string {
    NSArray* components = [string componentsSeparatedByString:@" "];

    if (components.count == 0) {
        return @"";
    }

    NSMutableString* identifier = [[components[0] lowercaseString] mutableCopy];

    for (int i = 1; i < components.count; i++) {
        [identifier appendString:[components[i] capitalizedString]];
    }

    return [identifier copy];
}

@end
