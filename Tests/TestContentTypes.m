//
//  TestContentTypes.m
//  ManagementSDK
//
//  Created by Boris Bügling on 29/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "BBURecordingHelper.h"

SpecBegin(ContentType)

describe(@"CMA", ^{
    __block CMAClient* client;
    __block CMASpace* space;

    RECORD_TESTCASE

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

    it(@"can activate a Content Type", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"foo" type:CDAFieldTypeDate] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil;

                                     [contentType publishWithSuccess:^{
                                         expect(contentType.sys[@"publishedCounter"]).equal(@1);

                                         [contentType unpublishWithSuccess:^{
                                             [contentType deleteWithSuccess:^{
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
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
    });

    it(@"can deactivate a Content Type", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"foo" type:CDAFieldTypeDate] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil;

                                     [contentType publishWithSuccess:^{
                                         expect(contentType.sys[@"publishedCounter"]).equal(@1);

                                         [contentType unpublishWithSuccess:^{
                                             expect(contentType.sys[@"publishedCounter"]).to.beNil;

                                             [contentType deleteWithSuccess:^{
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
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);
                                     
                                     done();
                                 }];
    });

    it(@"can create a new Content Type", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"Date" type:CDAFieldTypeDate],
                                            [CMAField fieldWithName:@"Bool" type:CDAFieldTypeBoolean],
                                            [CMAField fieldWithName:@"Loc" type:CDAFieldTypeLocation],
                                            [CMAField fieldWithName:@"Int" type:CDAFieldTypeInteger],
                                            [CMAField fieldWithName:@"Num" type:CDAFieldTypeNumber],
                                            [CMAField fieldWithName:@"Obj" type:CDAFieldTypeObject],
                                            [CMAField fieldWithName:@"Text" type:CDAFieldTypeText],
                                            [CMAField fieldWithName:@"Sym" type:CDAFieldTypeSymbol] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil;
                                     expect(contentType.fields.count).equal(8);

                                     [contentType deleteWithSuccess:^{
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

    it(@"can delete an existing Content Type", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:nil
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil;
                                     expect(contentType.fields.count).equal(0);

                                     [contentType deleteWithSuccess:^{
                                         [space fetchContentTypeWithIdentifier:contentType.identifier
                                                                       success:^(CDAResponse *response,
                                                                                 CMAContentType *ct) {
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
});

SpecEnd
