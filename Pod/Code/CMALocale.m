//
//  CMALocale.m
//  Pods
//
//  Created by Boris Bügling on 08/08/14.
//
//

#import "CDAResource+Management.h"
#import "CDAResource+Private.h"
#import "CMALocale.h"

@interface CMALocale ()

@property (nonatomic) NSString* code;
@property (nonatomic, getter = isDefault) BOOL defaultLocale;

@end

#pragma mark -

@implementation CMALocale

+(NSString *)CDAType {
    return @"Locale";
}

#pragma mark -

-(NSDictionary*)dictionaryRepresentation {
    return @{ @"name": self.name, @"code": self.code };
}

-(id)initWithDictionary:(NSDictionary *)dictionary client:(CDAClient *)client {
    self = [super initWithDictionary:dictionary client:client];
    if (self) {
        self.code = dictionary[@"code"];
        self.defaultLocale = [dictionary[@"default"] boolValue];
        self.name = dictionary[@"name"];
    }
    return self;
}

@end
