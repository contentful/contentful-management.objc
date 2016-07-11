//
//  CMAWebhook.m
//  Pods
//
//  Created by Boris Bügling on 11/07/16.
//

#import "CDAResource+Private.h"
#import "CMAWebhook.h"

@interface CMAWebhook ()

@property (nonatomic, copy) NSDictionary* headers;
@property (nonatomic, copy) NSString* httpBasicUsername;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSArray* topics;
@property (nonatomic, copy) NSURL* url;

@end

#pragma mark -

@implementation CMAWebhook

+(NSString *)CDAType {
    return @"WebhookDefinition";
}

#pragma mark -

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ '%@': %@", self.class.CDAType, self.name, self.url];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
                 client:(CDAClient *)client
  localizationAvailable:(BOOL)localizationAvailable {
    self = [super initWithDictionary:dictionary
                              client:client
               localizationAvailable:localizationAvailable];
    if (self) {
        self.httpBasicUsername = dictionary[@"httpBasicUsername"];
        self.name = dictionary[@"name"];
        self.topics = dictionary[@"topics"];

        NSMutableDictionary* headers = [@{} mutableCopy];
        [dictionary[@"headers"] enumerateObjectsUsingBlock:^(NSDictionary* pair,
                                                             NSUInteger idx, BOOL * stop) {
            headers[pair[@"key"]] = pair[@"value"];
        }];
        self.headers = headers;

        NSString* urlString = dictionary[@"url"];
        if (urlString) {
            self.url = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
