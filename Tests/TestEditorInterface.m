//
//  TestEditorInterface.m
//  ManagementSDK
//
//  Created by Boris Bügling on 22/12/15.
//  Copyright © 2015 Boris Bügling. All rights reserved.
//

#import <Keys/ManagementSDKKeys.h>
#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "BBURecordingHelper.h"

/*
 The spec name is a result of the test recordings being essential to a working testsuite right now
 and the recordings are order dependant.
 */
SpecBegin(XXX)

describe(@"EditorInterface", ^{
    __block CMAClient* client;
    __block CMASpace* space;

    RECORD_TESTCASE

    beforeEach(^{ waitUntil(^(DoneCallback done) {
        NSString* token = [ManagementsdkKeys new].managementAPIAccessToken;

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
    }); });

#if 0 // TODO: Test disabled for now because editor interface endpoint 404s here
    it(@"can fetch editor interface", ^{ waitUntil(^(DoneCallback done) {
        NSAssert(space, @"Test space could not be found.");
        [space fetchContentTypeWithIdentifier:@"3G3PM4Uth6Q4ymGG8iiasI"
                                      success:^(CDAResponse* response, CMAContentType* contentType) {
                                          [contentType fetchEditorInterfaceWithSuccess:^(CDAResponse*  response, CMAEditorInterface* interface) {
                                              XCTAssertNotNil(interface);

                                              done();
                                          } failure:^(CDAResponse* response, NSError* error) {
                                              XCTFail("Error: %@", error);

                                              done();
                                          }];

                                          XCTAssertNotNil(contentType);
                                      } failure:^(CDAResponse* response, NSError* error) {
                                          XCTFail("Error: %@", error);
                                          
                                          done();
                                      }];
    }); });
#endif
});

SpecEnd

