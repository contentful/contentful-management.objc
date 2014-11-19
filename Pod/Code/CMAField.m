//
//  CMAField.m
//  Pods
//
//  Created by Boris Bügling on 29/07/14.
//
//

#import "CDAField+Private.h"
#import "CMAField.h"
#import "CMAValidation+Private.h"

@interface CDAField ()

@property (nonatomic) NSMutableArray* mutableValidations;

-(NSDictionary*)dictionaryRepresentation;
-(void)setIdentifier:(NSString*)identifier;
-(void)setName:(NSString*)name;
-(void)setType:(CDAFieldType)type;

@end

#pragma mark -

@implementation CMAField

@dynamic itemType;
@synthesize mutableValidations = _mutableValidations;

#pragma mark -

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

#pragma mark -

-(void)addValidation:(CMAValidation*)validation {
    [self.mutableValidations addObject:validation];
}

-(NSDictionary*)dictionaryRepresentation {
    NSMutableDictionary* base = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    base[@"validations"] = [self.mutableValidations valueForKey:@"dictionaryRepresentation"];
    return [base copy];
}

-(id)initWithDictionary:(NSDictionary *)dictionary client:(CDAClient *)client {
    self = [super initWithDictionary:dictionary client:client];
    if (self) {
        self.mutableValidations = [@[] mutableCopy];

        for (NSDictionary* validation in dictionary[@"validations"]) {
            [self.mutableValidations addObject:[[CMAValidation alloc] initWithDictionary:validation]];
        }
    }
    return self;
}

-(NSArray *)validations {
    return [self.mutableValidations copy];
}

@end
