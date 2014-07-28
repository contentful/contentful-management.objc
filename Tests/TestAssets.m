//
//  TestAssets.m
//  ManagementSDK
//
//  Created by Boris Bügling on 28/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

SpecBegin(Asset)

describe(@"CMA", ^{
    __block CMAClient* client;
    __block CMASpace* space;

    beforeEach(^AsyncBlock {
        NSString* token = [[[NSProcessInfo processInfo] environment]
                           valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

        client = [[CMAClient alloc] initWithAccessToken:token];

        [client fetchSpaceWithIdentifier:@"xr0qbumw0cn0"
                                 success:^(CDAResponse *response, CMASpace *mySpace) {
                                     expect(space).toNot.beNil;
                                     space = mySpace;

                                     done();
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
    });

    it(@"can archive an Asset", ^AsyncBlock {
        [space createAssetWithFields:@{}
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 expect(asset).toNot.beNil;

                                 [asset archiveWithSuccess:^{
                                     expect(asset.sys[@"archivedVersion"]).equal(@1);

                                     done();
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
                             } failure:^(CDAResponse *response, NSError *error) {
                                 XCTFail(@"Error: %@", error);

                                 done();
                             }];
    });

    it(@"can create a new Asset", ^AsyncBlock {
        [space createAssetWithFields:@{ @"title": @{ @"en-US": @"My Asset" } }
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 expect(asset).toNot.beNil;

                                 expect(asset.identifier).toNot.beNil;
                                 expect(asset.sys[@"version"]).equal(@1);
                                 expect(asset.fields[@"title"]).equal(@"My Asset");

                                 done();
                             } failure:^(CDAResponse *response, NSError *error) {
                                 XCTFail(@"Error: %@", error);

                                 done();
                             }];
    });
});

SpecEnd
