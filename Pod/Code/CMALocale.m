//
//  CMALocale.m
//  Pods
//
//  Created by Boris Bügling on 08/08/14.
//
//

#import "CMALocale.h"
#import "CDAResource+Private.h"

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
        self.name = dictionary[@"name"];
    }
    return self;
}

@end
