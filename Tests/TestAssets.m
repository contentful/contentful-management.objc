//
//  TestAssets.m
//  ManagementSDK
//
//  Created by Boris Bügling on 28/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "BBURecordingHelper.h"
#import "CMASpace+Private.h"

SpecBegin(Asset)

describe(@"Asset", ^{
    __block CMAClient* client;
    __block CMASpace* space;

    RECORD_TESTCASE

    beforeEach(^AsyncBlock {
        NSString* token = [[[NSProcessInfo processInfo] environment]
                           valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

        client = [[CMAClient alloc] initWithAccessToken:token];

        [client fetchSpaceWithIdentifier:@"hvjkfbzcwrfn"
                                 success:^(CDAResponse *response, CMASpace *mySpace) {
                                     expect(mySpace).toNot.beNil();
                                     space = mySpace;

                                     done();
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
    });

    it(@"can be archived", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:nil
                        description:nil
                       fileToUpload:nil
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();
                                expect(asset.isArchived).to.beFalsy();

                                [asset archiveWithSuccess:^{
                                    expect(asset.sys[@"archivedVersion"]).equal(@1);
                                    expect(asset.isArchived).to.beTruthy();

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

    it(@"can be created", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:@{ @"en-US": @"My Asset" }
                        description:nil
                       fileToUpload:nil
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();

                                expect(asset.identifier).toNot.beNil();
                                expect(asset.sys[@"version"]).equal(@1);
                                expect(asset.fields[@"title"]).equal(@"My Asset");

                                done();
                            } failure:^(CDAResponse *response, NSError *error) {
                                XCTFail(@"Error: %@", error);

                                done();
                            }];
    });

    it(@"can be created with user-defined identifier", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithIdentifier:@"foo"
                                  fields:@{ @"title": @{ @"en-US": @"My Asset" } }
                                 success:^(CDAResponse *response, CMAAsset *asset) {
                                     expect(asset).toNot.beNil();

                                     expect(asset.identifier).equal(@"foo");
                                     expect(asset.sys[@"version"]).equal(@1);
                                     expect(asset.fields[@"title"]).equal(@"My Asset");

                                     [asset deleteWithSuccess:^{
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

    it(@"can be deleted", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:nil
                        description:nil
                       fileToUpload:nil
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();

                                [asset deleteWithSuccess:^{
                                    if (![BBURecordingHelper sharedHelper].isReplaying) {
                                        [NSThread sleepForTimeInterval:5.0];
                                    }

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

    it(@"can process its file", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:@{ @"en-US": @"Bacon Pancakes" }
                        description:nil
                       fileToUpload:@{ @"en-US": @"http://i.imgur.com/vaa4by0.png" }
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

    it(@"cannot be published without associated file", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:nil
                        description:nil
                       fileToUpload:nil
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();

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

    it(@"can be unarchived", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:nil
                        description:nil
                       fileToUpload:nil
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();

                                [asset archiveWithSuccess:^{
                                    expect(asset.sys[@"archivedVersion"]).equal(@1);

                                    [asset unarchiveWithSuccess:^{
                                        expect(asset.sys[@"archivedVersion"]).to.beNil();

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

    it(@"can be updated", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:@{ @"en-US": @"foo" }
                        description:nil
                       fileToUpload:nil
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();

                                asset.title = @"bar";

                                [asset updateWithSuccess:^{
                                    if (![BBURecordingHelper sharedHelper].isReplaying) {
                                        [NSThread sleepForTimeInterval:4.0];
                                    }

                                    [space fetchAssetWithIdentifier:asset.identifier success:^(CDAResponse *response, CMAAsset* newAsset) {
                                        expect(asset.fields[@"title"]).equal(@"bar");
                                        expect(asset.sys[@"version"]).equal(@2);

                                        expect(newAsset).toNot.beNil();
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

    it(@"can update its file", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createAssetWithTitle:nil
                        description:nil
                       fileToUpload:@{ @"en-US": @"http://i.imgur.com/vaa4by0.png" }
                            success:^(CDAResponse *response, CMAAsset *asset) {
                                expect(asset).toNot.beNil();
                                expect(asset.isImage).to.beTruthy();

                                [asset updateWithLocalizedUploads:@{ @"en-US": @"http://www.dogecoinforhumans.com/dogecoin-for-humans.pdf" }
                                                          success:^{
                                                              expect(asset).toNot.beNil();
                                                              expect(asset.isImage).to.beFalsy();

                                                              done();
                                                          } failure:^(CDAResponse *response,
                                                                      NSError *error) {
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
