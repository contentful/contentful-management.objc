//
//  ManagementSDKTests.m
//  ManagementSDKTests
//
//  Created by Boris Bügling on 07/14/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

SpecBegin(Spaces)

describe(@"retrieve Spaces", ^{
    __block CMAClient* client;

    beforeEach(^{
        NSString* token = [[[NSProcessInfo processInfo] environment]
                           valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

        client = [[CMAClient alloc] initWithAccessToken:token];
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

    it(@"can change the name of a Space", ^AsyncBlock {
        [client fetchSpaceWithIdentifier:@"xr0qbumw0cn0" success:^(CDAResponse *response,
                                                                   CMASpace *space) {
            expect(space).toNot.beNil;
            space.name = @"foo";

            [space updateWithSuccess:^{
                expect(space.name).to.equal(@"foo");

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
});

SpecEnd
