//
//  TestSpaces.m
//  TestSpaces
//
//  Created by Boris Bügling on 07/14/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "BBURecordingHelper.h"

SpecBegin(Spaces)

describe(@"CMA", ^{
    __block CMAClient* client;
    __block CMAOrganization* organization;

    RECORD_TESTCASE

    beforeEach(^AsyncBlock {
        NSString* token = [[[NSProcessInfo processInfo] environment]
                           valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

        client = [[CMAClient alloc] initWithAccessToken:token];

        [client fetchOrganizationsWithSuccess:^(CDAResponse *response, CDAArray *array) {
            for (CMAOrganization* item in array.items) {
                if ([item.identifier isEqualToString:@"1PLOOEmTI2S1NYald2TemO"]) {
                    organization = item;
                }
            }

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve all Organizations of an account", ^AsyncBlock {
        NSAssert(client, @"Client is not available.");
        [client fetchOrganizationsWithSuccess:^(CDAResponse *response, CDAArray *array) {
            expect(array.items.count).equal(5);

            for (CMAOrganization* organization in array.items) {
                expect(organization.name).toNot.beNil();
                expect(organization.isActive).equal(YES);
            }

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve all Spaces of an account", ^AsyncBlock {
        NSAssert(client, @"Client is not available.");
        [client fetchAllSpacesWithSuccess:^(CDAResponse *response, CDAArray *array) {
            expect(response).toNot.beNil();

            expect(array).toNot.beNil();
            expect(array.items.count).to.equal(24);
            expect([array.items[0] class]).to.equal([CMASpace class]);

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve a single Space", ^AsyncBlock {
        NSAssert(client, @"Client is not available.");
        [client fetchSpaceWithIdentifier:@"hvjkfbzcwrfn" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(response).toNot.beNil();

            expect(space).toNot.beNil();
            expect(space.identifier).to.equal(@"hvjkfbzcwrfn");
            expect(space.name).to.equal(@"CMA SDK Test");

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve the Content Types of a Space", ^AsyncBlock {
        NSAssert(client, @"Client is not available.");
        [client fetchSpaceWithIdentifier:@"hvjkfbzcwrfn" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(space).toNot.beNil();

            [space fetchContentTypesWithSuccess:^(CDAResponse *response, CDAArray *array) {
                expect(array).toNot.beNil();
                expect(array.items.count).equal(3);
                expect([array.items[0] identifier]).toNot.beNil();

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

// FIXME: Deactivated because of rate-limiting, will reactivate once VCR is integrated.
#if 0
    it(@"can create a new Space", ^AsyncBlock {
        NSAssert(client, @"Client is not available.");
        [client createSpaceWithName:@"MySpace"
                            success:^(CDAResponse *response, CMASpace *space) {
                                expect(space).toNot.beNil();
                                expect(space.name).equal(@"MySpace");
                                expect(space.identifier).toNot.beNil();

                                [client fetchSpaceWithIdentifier:space.identifier
                                                         success:^(CDAResponse *response,
                                                                   CMASpace *newSpace) {
                                                             expect(newSpace).toNot.beNil();
                                                             expect(newSpace.name).equal(@"MySpace");

                                                             [space deleteWithSuccess:^{
                                                                 done();
                                                             } failure:^(CDAResponse *response,
                                                                         NSError *error) {
                                                                 XCTFail(@"Error: %@", error);

                                                                 done();
                                                             }];
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

    it(@"can create a new Space within a specific Organization", ^AsyncBlock {
        expect(organization).toNot.beNil;

        NSAssert(client, @"Client is not available.");
        [client createSpaceWithName:@"MySpace"
                     inOrganization:organization
                            success:^(CDAResponse *response, CMASpace *space) {
                                expect(space).toNot.beNil();
                                expect(space.name).equal(@"MySpace");
                                expect(space.identifier).toNot.beNil();

                                [client fetchSpaceWithIdentifier:space.identifier
                                                         success:^(CDAResponse *response,
                                                                   CMASpace *newSpace) {
                                                             expect(newSpace).toNot.beNil();
                                                             expect(newSpace.name).equal(@"MySpace");

                                                             [space deleteWithSuccess:^{
                                                                 done();
                                                             } failure:^(CDAResponse *response,
                                                                         NSError *error) {
                                                                 XCTFail(@"Error: %@", error);

                                                                 done();
                                                             }];
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

    it(@"can delete an existing Space", ^AsyncBlock  {
        NSAssert(client, @"Client is not available.");
        [client createSpaceWithName:@"MySpace"
                            success:^(CDAResponse *response, CMASpace *space) {
                                expect(space).toNot.beNil();

                                [space deleteWithSuccess:^{
                                    [client fetchSpaceWithIdentifier:space.identifier
                                                             success:^(CDAResponse *response,
                                                                       CMASpace *space) {
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
#endif

    it(@"can change the name of a Space", ^AsyncBlock {
        NSAssert(client, @"Client is not available.");
        [client fetchSpaceWithIdentifier:@"hvjkfbzcwrfn" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(space).toNot.beNil();
            NSString* originalName = space.name;
            space.name = @"foo";

            [space updateWithSuccess:^{
                expect(space.name).to.equal(@"foo");

                space.name = originalName;

                [space updateWithSuccess:^{
                    expect(space.name).to.equal(originalName);

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
