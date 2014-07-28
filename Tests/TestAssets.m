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

    it(@"can delete an existing Asset", ^AsyncBlock {
        [space createAssetWithFields:@{}
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 expect(asset).toNot.beNil;

                                 [asset deleteWithSuccess:^{
                                     [space fetchAssetWithIdentifier:asset.identifier
                                                             success:^(CDAResponse *response,
                                                                       CMAAsset *asset) {
                                                                 XCTFail(@"Should not succeed.");

                                                                 done();
                                                             } failure:^(CDAResponse *response,
                                                                         NSError *error) {
                                                                 done();
                                                             }];
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
                             } failure:^(CDAResponse *response, NSError *error) {
                                 XCTFail(@"Error: %@", error);

                                 done();
                             }];
    });

    it(@"can process the file of an Asset", ^AsyncBlock {
        NSDictionary* fileData = @{ @"upload": @"http://i.imgur.com/vaa4by0.png",
                                    @"contentType": @"image/png",
                                    @"fileName": @"doge.png" };

        [space createAssetWithFields:@{ @"title": @{ @"en-US": @"Bacon Pancakes" },
                                        @"file": @{ @"en-US": fileData } }
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 [asset processWithSuccess:^{
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

    it(@"cannot publish an Asset without associated file", ^AsyncBlock {
        [space createAssetWithFields:@{}
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 expect(asset).toNot.beNil;

                                 [asset publishWithSuccess:^{
                                     XCTFail(@"Should not succeed.");

                                     done();
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     done();
                                 }];
                             } failure:^(CDAResponse *response, NSError *error) {
                                 XCTFail(@"Error: %@", error);

                                 done();
                             }];
    });

    it(@"can unarchive an Asset", ^AsyncBlock {
        [space createAssetWithFields:@{}
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 expect(asset).toNot.beNil;

                                 [asset archiveWithSuccess:^{
                                     expect(asset.sys[@"archivedVersion"]).equal(@1);

                                     [asset unarchiveWithSuccess:^{
                                         expect(asset.sys[@"archivedVersion"]).to.beNil;

                                         done();
                                     } failure:^(CDAResponse *response, NSError *error) {
                                         XCTFail(@"Error: %@", error);

                                         done();
                                     }];
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
                             } failure:^(CDAResponse *response, NSError *error) {
                                 XCTFail(@"Error: %@", error);
                                 
                                 done();
                             }];
    });

    it(@"can update an Asset", ^AsyncBlock {
        [space createAssetWithFields:@{ @"title": @{ @"en-US": @"foo" } }
                             success:^(CDAResponse *response, CMAAsset *asset) {
                                 expect(asset).toNot.beNil;

                                 asset.title = @"bar";

                                 [asset updateWithSuccess:^{
                                     // FIXME: There has to be a better way...
                                     [NSThread sleepForTimeInterval:5.0];

                                     [space fetchAssetWithIdentifier:asset.identifier success:^(CDAResponse *response, CMAAsset* newAsset) {
                                         expect(asset.fields[@"title"]).equal(@"bar");
                                         expect(asset.sys[@"version"]).equal(@2);

                                         expect(newAsset).toNot.beNil;
                                         expect(newAsset.fields[@"title"]).equal(@"bar");
                                         expect(newAsset.sys[@"version"]).equal(@2);

                                         done();
                                     } failure:^(CDAResponse *response, NSError *error) {
                                         XCTFail(@"Error: %@", error);

                                         done();
                                     }];
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
                             } failure:^(CDAResponse *response, NSError *error) {
                                 XCTFail(@"Error: %@", error);
                                 
                                 done();
                             }];
    });
});

SpecEnd
