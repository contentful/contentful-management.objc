//
//  CMASpace.m
//  ManagementSDK
//
//  Created by Boris Bügling on 15/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "CDAClient+Private.h"
#import "CDAResource+Management.h"
#import "CMASpace+Private.h"

@interface CMASpace ()

@property (nonatomic) CDAClient* apiClient;;

@end

#pragma mark -

@implementation CMASpace

@dynamic name;

#pragma mark -

+(NSString*)determineMIMETypeOfResourceAtURL:(NSURL*)url error:(NSError**)error {
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                         returningResponse:&response
                                                     error:error];

    if (!data) {
        return nil;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.allHeaderFields[@"Content-Type"];
    }

    // FIXME: Return an error in this case
    return nil;
}

+(NSDictionary*)fileUploadDictionaryFromLocalizedUploads:(NSDictionary*)localizedUploads {
    NSMutableDictionary* fileDictionary = [@{} mutableCopy];

    [localizedUploads enumerateKeysAndObjectsUsingBlock:^(NSString* language,
                                                          NSString* fileUrl,
                                                          BOOL *stop) {
        NSString* mimeType = [[self class] determineMIMETypeOfResourceAtURL:[NSURL URLWithString:fileUrl]
                                                                      error:nil];

        fileDictionary[language] = @{ @"upload": fileUrl,
                                      @"contentType": mimeType,
                                      @"fileName": [fileUrl lastPathComponent] };
    }];

    return fileDictionary;
}

#pragma mark -

-(CDAClient *)client {
    return self.apiClient;
}

-(void)setClient:(CDAClient *)client {
    NSParameterAssert(client);
    self.apiClient = [client copyWithSpace:self];
}

-(CDARequest *)createAssetWithFields:(NSDictionary *)fields
                             success:(CMAAssetFetchedBlock)success
                             failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client postURLPath:@"assets"
                            headers:nil
                         parameters:@{ @"fields": fields }
                            success:success
                            failure:failure];
}

-(CDARequest *)createAssetWithIdentifier:(NSString*)identifier
                                  fields:(NSDictionary *)fields
                                 success:(CMAAssetFetchedBlock)success
                                 failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[@"assets" stringByAppendingPathComponent:identifier]
                           headers:nil
                        parameters:@{ @"fields": fields }
                           success:success
                           failure:failure];
}

-(void)createAssetWithTitle:(NSDictionary *)titleDictionary
                description:(NSDictionary *)descriptionDictionary
               fileToUpload:(NSDictionary *)fileUploadDictionary
                    success:(CMAAssetFetchedBlock)success
                    failure:(CDARequestFailureBlock)failure {
    NSMutableDictionary* fields = [@{} mutableCopy];

    if (titleDictionary.count > 0) {
        fields[@"title"] = titleDictionary;
    }

    if (descriptionDictionary.count > 0) {
        fields[@"description"] = descriptionDictionary;
    }

    if (fileUploadDictionary.count == 0) {
        [self createAssetWithFields:[fields copy] success:success failure:failure];
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        fields[@"file"] = [[self class] fileUploadDictionaryFromLocalizedUploads:fileUploadDictionary];
        [self createAssetWithFields:[fields copy] success:success failure:failure];
    });
}

-(CDARequest *)createContentTypeWithName:(NSString*)name
                                  fields:(NSArray*)fields
                                 success:(CMAContentTypeFetchedBlock)success
                                 failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);

    NSArray* fieldsAsDictionaries = fields ? [fields valueForKey:@"dictionaryRepresentation"] : @[];

    return [self.client postURLPath:@"content_types"
                            headers:nil
                         parameters:@{ @"name": name, @"fields": fieldsAsDictionaries }
                            success:success
                            failure:failure];
}

-(CDARequest *)createEntryOfContentType:(CMAContentType*)contentType
                             withFields:(NSDictionary *)fields
                                success:(CMAEntryFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client postURLPath:@"entries"
                            headers:@{ @"X-Contentful-Content-Type": contentType.identifier }
                         parameters:@{ @"fields": fields }
                            success:success
                            failure:failure];
}

-(CDARequest *)createEntryOfContentType:(CMAContentType *)contentType
                         withIdentifier:(NSString *)identifier
                                 fields:(NSDictionary *)fields
                                success:(CMAEntryFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[@"entries" stringByAppendingPathComponent:identifier]
                           headers:@{ @"X-Contentful-Content-Type": contentType.identifier }
                        parameters:@{ @"fields": fields }
                           success:success
                           failure:failure];
}

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"" withSuccess:success failure:failure];
}

-(CDARequest *)fetchAssetWithIdentifier:(NSString *)identifier
                                success:(CMAAssetFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchAssetWithIdentifier:identifier
                                         success:^(CDAResponse *response, CDAAsset *asset) {
                                             if (success) {
                                                 success(response, (CMAAsset*)asset);
                                             }
                                         } failure:failure];
}

-(CDARequest *)fetchContentTypesWithSuccess:(CDAArrayFetchedBlock)success
                                    failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchContentTypesWithSuccess:success failure:failure];
}

-(CDARequest *)fetchContentTypeWithIdentifier:(NSString *)identifier
                                      success:(CMAContentTypeFetchedBlock)success
                                      failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchContentTypeWithIdentifier:identifier
                                               success:^(CDAResponse *response,
                                                         CDAContentType *contentType) {
                                                   if (success) {
                                                       success(response, (CMAContentType*)contentType);
                                                   }
                                               } failure:failure];
}

-(CDARequest *)fetchEntryWithIdentifier:(NSString *)identifier
                                success:(CDAEntryFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchEntryWithIdentifier:identifier success:success failure:failure];
}

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@""
                       withParameters:@{ @"name": self.name }
                              success:success
                              failure:failure];
}

-(NSString *)URLPath {
    return @"";
}

@end
