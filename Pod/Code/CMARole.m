//
//  CMARole.m
//  Pods
//
//  Created by Boris Bügling on 05/07/16.
//

#import "CDAResource+Private.h"
#import "CMARole.h"

@interface CMARole ()

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSDictionary* permissions;
@property (nonatomic, copy) NSArray* policies;
@property (nonatomic, copy) NSString* roleDescription;

@end

#pragma mark -

@implementation CMARole

+(NSString *)CDAType {
    return @"Role";
}

#pragma mark -

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ '%@'", self.class.CDAType, self.name];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
                 client:(CDAClient *)client
  localizationAvailable:(BOOL)localizationAvailable {
    self = [super initWithDictionary:dictionary
                              client:client
               localizationAvailable:localizationAvailable];
    if (self) {
        self.name = dictionary[@"name"];
        self.permissions = dictionary[@"permissions"];
        self.policies = dictionary[@"policies"];
        self.roleDescription = dictionary[@"description"];
    }
    return self;
}

@end
