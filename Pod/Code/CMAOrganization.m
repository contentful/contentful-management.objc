//
//  CMAOrganization.m
//  Pods
//
//  Created by Boris Bügling on 29/07/14.
//
//

#import "CMAOrganization.h"
#import "CDAResource+Private.h"

@interface CMAOrganization ()

@property (nonatomic, getter = isActive) BOOL active;
@property (nonatomic) NSString* name;

@end

#pragma mark -

@implementation CMAOrganization

+(NSString *)CDAType {
    return @"Organization";
}

#pragma mark - 

-(NSString *)description {
    return [NSString stringWithFormat:@"CMAOrganization %@ with name: %@", self.identifier, self.name];
}

-(id)initWithDictionary:(NSDictionary *)dictionary client:(CDAClient *)client {
    self = [super initWithDictionary:dictionary client:client];
    if (self) {
        self.active = [dictionary[@"subscriptionState"] isEqualToString:@"active"];
        self.name = dictionary[@"name"];
    }
    return self;
}

@end
