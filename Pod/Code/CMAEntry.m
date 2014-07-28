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

@property (nonatomic, readonly) NSString* URLPath;

@end

#pragma mark -

@implementation CMAEntry

-(CDARequest *)archiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"archived" withSuccess:success failure:failure];
}

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

-(CDARequest*)performDeleteToFragment:(NSString*)fragment
                          withSuccess:(void (^)())success
                              failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client deleteURLPath:[self.URLPath stringByAppendingPathComponent:fragment]
                              headers:nil
                           parameters:nil
                              success:^(CDAResponse *response, CMAEntry* entry) {
                                  [self updateWithResource:entry];

                                  if (success) {
                                      success();
                                  }
                              } failure:failure];
}

-(CDARequest*)performPutToFragment:(NSString*)fragment
                       withSuccess:(void (^)())success
                           failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[self.URLPath stringByAppendingPathComponent:fragment]
                           headers:@{ @"X-Contentful-Version": [self.sys[@"version"] stringValue] }
                        parameters:nil
                           success:^(CDAResponse *response, CMAEntry* entry) {
                               [self updateWithResource:entry];

                               if (success) {
                                   success();
                               }
                           } failure:failure];
}

-(CDARequest *)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"published" withSuccess:success failure:failure];
}

-(void)setValue:(id)value forFieldWithName:(NSString *)key {
    [super setValue:value forFieldWithName:key];
}

-(CDARequest *)unarchiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"archived" withSuccess:success failure:failure];
}

-(CDARequest *)unpublishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"published" withSuccess:success failure:failure];
}

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:self.URLPath
                           headers:@{ @"X-Contentful-Version": [self.sys[@"version"] stringValue] }
                        parameters:@{ @"fields" : [self parametersFromLocalizedFields] }
                           success:^(CDAResponse *response, CMAEntry* entry) {
                               [self updateWithResource:entry];

                               if (success) success();
                           } failure:failure];
}

-(NSString *)URLPath {
    return [@"entries" stringByAppendingPathComponent:self.identifier];
}

@end
