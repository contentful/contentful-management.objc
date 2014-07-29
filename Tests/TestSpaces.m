//
//  TestSpaces.m
//  TestSpaces
//
//  Created by Boris Bügling on 07/14/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

SpecBegin(Spaces)

describe(@"CMA", ^{
    __block CMAClient* client;

    beforeEach(^{
        NSString* token = [[[NSProcessInfo processInfo] environment]
                           valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

        client = [[CMAClient alloc] initWithAccessToken:token];
    });

    it(@"can retrieve all Organizations of an account", ^AsyncBlock {
        [client fetchOrganizationsWithSuccess:^(CDAResponse *response, CDAArray *array) {
            expect(array.items.count).equal(5);

            for (CMAOrganization* organization in array.items) {
                expect(organization.name).toNot.beNil;
                expect(organization.isActive).equal(YES);
            }

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve all Spaces of an account", ^AsyncBlock {
        [client fetchAllSpacesWithSuccess:^(CDAResponse *response, CDAArray *array) {
            expect(response).toNot.beNil;

            expect(array).toNot.beNil;
            expect(array.items.count).to.equal(23);
            expect([array.items[0] class]).to.equal([CMASpace class]);

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve a single Space", ^AsyncBlock {
        [client fetchSpaceWithIdentifier:@"xr0qbumw0cn0" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(response).toNot.beNil;

            expect(space).toNot.beNil;
            expect(space.identifier).to.equal(@"xr0qbumw0cn0");
            expect(space.name).to.equal(@"test");

            done();
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);

            done();
        }];
    });

    it(@"can retrieve the Content Types of a Space", ^AsyncBlock {
        [client fetchSpaceWithIdentifier:@"xr0qbumw0cn0" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(space).toNot.beNil;

            [space fetchContentTypesWithSuccess:^(CDAResponse *response, CDAArray *array) {
                expect(array).toNot.beNil;
                expect(array.items.count).equal(1);
                expect([array.items[0] identifier]).toNot.beNil;

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

    it(@"can change the name of a Space", ^AsyncBlock {
        [client fetchSpaceWithIdentifier:@"xr0qbumw0cn0" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(space).toNot.beNil;
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
