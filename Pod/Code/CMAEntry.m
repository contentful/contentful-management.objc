//
//  CMAEntry.m
//  Pods
//
//  Created by Boris Bügling on 25/07/14.
//
//

#import "CDAClient+Private.h"
#import "CMAClient.h"
#import "CDAEntry+Private.h"
#import "CMAEntry.h"
#import "CDAResource+Private.h"

@interface CMAEntry ()

@property (nonatomic) NSString* URLPath;

@end

#pragma mark -

@implementation CMAEntry

-(CDARequest*)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client deleteURLPath:self.URLPath
                              headers:nil
                           parameters:nil
                              success:^(CDAResponse *response, id responseObject) {
                                  if (success) {
                                      success();
                                  }
                              } failure:failure];
}

-(NSDictionary*)parametersFromLocalizedFields {
    NSMutableDictionary* result = [@{} mutableCopy];

    [self.localizedFields enumerateKeysAndObjectsUsingBlock:^(NSString* language,
                                                              NSDictionary* values, BOOL *stop) {
        [values enumerateKeysAndObjectsUsingBlock:^(NSString* fieldName, id value, BOOL *stop) {
            NSMutableDictionary* fieldValues = result[fieldName] ?: [@{} mutableCopy];
            fieldValues[language] = value;
            result[fieldName] = fieldValues;
        }];
    }];

    return [result copy];
}

-(CDARequest *)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[self.URLPath stringByAppendingPathComponent:@"published"]
                           headers:@{ @"X-Contentful-Version": [self.sys[@"version"] stringValue] }
                        parameters:nil
                           success:^(CDAResponse *response, CMAEntry* entry) {
                               [self updateWithResource:entry];

                               if (success) {
                                   success();
                               }
                           } failure:failure];
}

-(void)setValue:(id)value forFieldWithName:(NSString *)key {
    [super setValue:value forFieldWithName:key];
}

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:self.URLPath
                           headers:@{ @"X-Contentful-Version": [self.sys[@"version"] stringValue] }
                        parameters:@{ @"fields" : [self parametersFromLocalizedFields] }
                           success:^(CDAResponse *response, CMASpace* space) {
                               [self updateWithResource:space];

                               if (success) success();
                           } failure:failure];
}

-(NSString *)URLPath {
    return [@"entries" stringByAppendingPathComponent:self.identifier];
}

@end
