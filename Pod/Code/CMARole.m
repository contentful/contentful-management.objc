//
//  CMARole.m
//  Pods
//
//  Created by Boris Bügling on 05/07/16.
//

#import "CDAResource+Private.h"
#import "CDAResource+Management.h"
#import "CMARole.h"

@implementation CMARole

+(NSString *)CDAType {
    return @"Role";
}

#pragma mark -

-(CDARequest*)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"" withSuccess:success failure:failure];
}

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

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@""
                       withParameters:@{ @"name": self.name,
                                         @"permissions": self.permissions,
                                         @"policies": self.policies,
                                         @"description": self.roleDescription
                                       }
                              success:success
                              failure:failure];
}

-(NSString *)URLPath {
    return [@"roles" stringByAppendingPathComponent:self.identifier];
}

@end
