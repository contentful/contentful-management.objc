//
//  CMAAsset.m
//  Pods
//
//  Created by Boris Bügling on 28/07/14.
//
//

#import "CDAAsset+Private.h"
#import "CDAResource+Management.h"
#import "CDAResource+Private.h"
#import "CMAAsset.h"
#import "CMASpace+Private.h"
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

-(NSString *)description {
    return self.fields[@"description"];
}

-(BOOL)isPublished {
    return self.sys[@"publishedVersion"] != nil;
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

-(void)setDescription:(NSString *)description {
    [self setValue:description forFieldWithName:@"description"];
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

-(void)updateWithResource:(CDAResource *)resource {
    [super updateWithResource:resource];

    if (!resource) {
        return;
    }

    NSAssert([resource isKindOfClass:[CDAAsset class]], @"Given resource should be an asset.");
    CDAAsset* asset = (CDAAsset*)resource;

    [self.localizedFields enumerateKeysAndObjectsUsingBlock:^(NSString* language, NSDictionary* fields,
                                                              BOOL *stop) {
        asset.locale = language;
        self.locale = language;

        for (NSString* relevantField in @[ @"file" ]) {
            id value = asset.fields[relevantField];

            if (value) {
                [self setValue:value forFieldWithName:relevantField];
            }
        }
    }];
}

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@""
                       withParameters:@{ @"fields" : [self parametersFromLocalizedFields] }
                              success:success
                              failure:failure];
}

-(CDARequest *)updateWithLocalizedUploads:(NSDictionary*)localizedUploads
                                  success:(void (^)())success
                                  failure:(CDARequestFailureBlock)failure {
    NSMutableDictionary* parameters = [[self parametersFromLocalizedFields] mutableCopy];

    if (localizedUploads.count > 0) {
        parameters[@"file"] = [CMASpace fileUploadDictionaryFromLocalizedUploads:localizedUploads];
    }

    return [self performPutToFragment:@""
                       withParameters:@{ @"fields" : parameters }
                              success:success
                              failure:failure];
}

-(NSString *)URLPath {
    return [@"assets" stringByAppendingPathComponent:self.identifier];
}

@end
