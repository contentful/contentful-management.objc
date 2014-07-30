//
//  CMAAsset.m
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import "CDAAsset+Private.h"
#import "CDAResource+Management.h"
#import "CMAAsset.h"
#import "CMAUtilities.h"

@interface CMAAsset ()

@property (nonatomic, readonly) NSString* URLPath;

@end

#pragma mark -

@implementation CMAAsset

-(CDARequest *)archiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"archived" withSuccess:success failure:failure];
}

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"" withSuccess:success failure:failure];
}

-(NSDictionary*)parametersFromLocalizedFields {
    return CMATransformLocalizedFieldsToParameterDictionary(self.localizedFields);
}

-(CDARequest *)processWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:[NSString stringWithFormat:@"files/%@/process", self.locale]
                          withSuccess:success
                              failure:failure];
}

-(CDARequest *)publishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@"published" withSuccess:success failure:failure];
}

-(void)setTitle:(NSString *)title {
    [self setValue:title forFieldWithName:@"title"];
}

-(NSString *)title {
    return self.fields[@"title"];
}

-(CDARequest *)unarchiveWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"archived" withSuccess:success failure:failure];
}

-(CDARequest *)unpublishWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"published" withSuccess:success failure:failure];
}

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@""
                       withParameters:@{ @"fields" : [self parametersFromLocalizedFields] }
                              success:success
                              failure:failure];
}

-(NSString *)URLPath {
    return [@"assets" stringByAppendingPathComponent:self.identifier];
}

@end
