//
//  TestEntries.m
//  ManagementSDK
//
//  Created by Boris Bügling on 23/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

// TODO: Should cleanup / delete entries after tests

SpecBegin(Entry)

describe(@"CMA", ^{
    __block CMAClient* client;
    __block CMAContentType* contentType;
    __block CMASpace* space;

    beforeEach(^AsyncBlock {
        NSString* token = [[[NSProcessInfo processInfo] environment]
                           valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

        client = [[CMAClient alloc] initWithAccessToken:token];

        [client fetchSpaceWithIdentifier:@"xr0qbumw0cn0"
                                 success:^(CDAResponse *response, CMASpace *mySpace) {
                                     expect(space).toNot.beNil;
                                     space = mySpace;

                                     [space fetchContentTypesWithSuccess:^(CDAResponse *response,
                                                                           CDAArray *array) {
                                         expect(array).toNot.beNil;
                                         expect(array.items.count).to.equal(1);

                                         contentType = array.items[0];
                                         expect(contentType.identifier).toNot.beNil;

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

    it(@"can archive an Entry", ^AsyncBlock {
        [space createEntryOfContentType:contentType
                             withFields:@{}
                                success:^(CDAResponse *response, CMAEntry *entry) {
                                    [entry archiveWithSuccess:^{
                                        expect(entry.sys[@"archivedVersion"]).equal(@1);

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

    it(@"can create a new Entry", ^AsyncBlock {
        [space createEntryOfContentType:contentType
                             withFields:@{ @"title": @{ @"en-US": @"Mr. President" } }
                                success:^(CDAResponse *response, CDAEntry *entry) {
                                    expect(entry).toNot.beNil;

                                    expect(entry.identifier).toNot.beNil;
                                    expect(entry.sys[@"version"]).equal(@1);
                                    expect(entry.fields[@"title"]).equal(@"Mr. President");

                                    done();
                                } failure:^(CDAResponse *response, NSError *error) {
                                    XCTFail(@"Error: %@", error);

                                    done();
                                }];
    });

    it(@"can delete an existing Entry", ^AsyncBlock {
        [space createEntryOfContentType:contentType
                             withFields:@{}
                                success:^(CDAResponse *response, CMAEntry *entry) {
                                    expect(entry).toNot.beNil;

                                    [entry deleteWithSuccess:^{
                                        [space fetchEntryWithIdentifier:entry.identifier
                                                                success:^(CDAResponse *response,
                                                                          CDAEntry *entry) {
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

    it(@"can publish an Entry", ^AsyncBlock {
        [space createEntryOfContentType:contentType
                             withFields:@{}
                                success:^(CDAResponse *response, CMAEntry *entry) {
                                    [entry publishWithSuccess:^{
                                        expect(entry.sys[@"publishedCounter"]).equal(@1);

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

    it(@"can unpublish an Entry", ^AsyncBlock {
        [space createEntryOfContentType:contentType
                             withFields:@{}
                                success:^(CDAResponse *response, CMAEntry *entry) {
                                    [entry publishWithSuccess:^{
                                        expect(entry.sys[@"publishedCounter"]).equal(@1);

                                        [entry unpublishWithSuccess:^{
                                            expect(entry.sys[@"publishedCounter"]).to.beNil;

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

    it(@"can update an Entry", ^AsyncBlock {
        [space createEntryOfContentType:contentType
                             withFields:@{ @"title": @{ @"en-US": @"foo" } }
                                success:^(CDAResponse *response, CMAEntry *entry) {
                                    expect(entry).toNot.beNil;

                                    [entry setValue:@"bar" forFieldWithName:@"title"];
                                    [entry updateWithSuccess:^{
                                        // FIXME: There has to be a better way...
                                        [NSThread sleepForTimeInterval:5.0];

                                        [space fetchEntryWithIdentifier:entry.identifier success:^  (CDAResponse *response, CDAEntry *newEntry) {
                                            expect(entry.fields[@"title"]).equal(@"bar");
                                            expect(entry.sys[@"version"]).equal(@2);

                                            expect(newEntry).toNot.beNil;
                                            expect(newEntry.fields[@"title"]).equal(@"bar");
                                            expect(newEntry.sys[@"version"]).equal(@2);

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
