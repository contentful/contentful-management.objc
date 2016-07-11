//
//  TestWebhooks.m
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
SpecBegin(XXXX)

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

    it(@"can fetch all webhooks for a space", ^{ waitUntil(^(DoneCallback done) {
        NSAssert(space, @"Test space could not be found.");
        [space fetchWebhooksWithSuccess:^(CDAResponse* response, CDAArray* array) {
            XCTAssertEqual(array.items.count, 1);

            done();
        } failure:^(CDAResponse* response, NSError* error) {
            XCTFail("Error: %@", error);

            done();
        }];
    }); });

    it(@"can create a new webhook", ^{ waitUntil(^(DoneCallback done) {
        NSAssert(space, @"Test space could not be found.");

        NSString* name = @"yolo";
        NSURL* url = [NSURL URLWithString:@"http://example.com/example"];

        [space createWebhookWithName:name
                                 url:url
                              topics:nil
                             headers:nil
                   httpBasicUsername:nil
                   httpBasicPassword:nil
                             success:^(CDAResponse* response, CMAWebhook* webhook) {
                                 XCTAssertNotNil(webhook);
                                 XCTAssertEqualObjects(webhook.name, name);
                                 XCTAssertEqualObjects(webhook.url, url);
                                 XCTAssertEqualObjects(webhook.topics, @[ @"*.*" ]);
                                 XCTAssertNil(webhook.headers);
                                 XCTAssertNil(webhook.httpBasicUsername);
                                 XCTAssertNil(webhook.httpBasicPassword);

                                 done();
                             } failure:^(CDAResponse* response, NSError* error) {
                                 XCTFail("Error: %@", error);

                                 done();
                             }];
    }); });

    it(@"can fetch a single webhook", ^{ waitUntil(^(DoneCallback done) {
        NSAssert(space, @"Test space could not be found.");
        [space fetchWebhookWithIdentifier:@"3ylg2m4MZEnhggGFyI0gyJ"
                                  success:^(CDAResponse* response, CMAWebhook* webhook) {
                                      XCTAssertNotNil(webhook);
                                      XCTAssertEqualObjects(webhook.name, @"yolo");
                                      XCTAssertEqualObjects(webhook.url, [NSURL URLWithString:@"http://example.com"]);
                                      XCTAssertEqualObjects(webhook.topics, (@[ @"Entry.archive" ]));
                                      XCTAssertEqualObjects(webhook.headers, (@{ @"foo": @"bar", @"moo": @"foo" }));
                                      XCTAssertEqualObjects(webhook.httpBasicUsername, @"yolo");

                                      done();
                                  } failure:^(CDAResponse* response, NSError* error) {
                                      XCTFail("Error: %@", error);

                                      done();
                                  }];
    }); });
});

SpecEnd

