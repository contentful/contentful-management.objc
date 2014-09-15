//
//  TestContentTypes.m
//  ManagementSDK
//
//  Created by Boris Bügling on 29/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <CocoaPods-Keys/ManagementSDKKeys.h>
#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "BBURecordingHelper.h"

#define ArrayTestWithItemType(__itemType) NSAssert(space, @"Test space could not be found."); \
\
CMAField* arrayField = [CMAField fieldWithName:@"Array" type:CDAFieldTypeArray]; \
arrayField.itemType = __itemType; \
\
[space createContentTypeWithName:@"foobar" \
                          fields:@[ arrayField ] \
                         success:^(CDAResponse *response, CMAContentType *contentType) { \
                             expect(contentType).toNot.beNil(); \
                             expect(contentType.fields.count).to.equal(1); \
\
                             [contentType publishWithSuccess:^{ \
                                 expect(contentType).toNot.beNil(); \
                                 expect(contentType.fields.count).to.equal(1); \
\
                                 [contentType unpublishWithSuccess:^{ \
                                     expect(contentType).toNot.beNil(); \
                                     expect(contentType.fields.count).to.equal(1); \
\
                                     [contentType deleteWithSuccess:^{ \
                                         done(); \
                                     } failure:^(CDAResponse *response, NSError *error) { \
                                         XCTFail(@"Error: %@", error); \
\
                                         done(); \
                                     }]; \
                                 } failure:^(CDAResponse *response, NSError *error) { \
                                     XCTFail(@"Error: %@", error); \
\
                                     done(); \
                                 }]; \
                             } failure:^(CDAResponse *response, NSError *error) { \
                                 XCTFail(@"Error: %@", error); \
\
                                 done(); \
                             }]; \
                         } failure:^(CDAResponse *response, NSError *error) { \
                             XCTFail(@"Error: %@", error); \
\
                             done(); \
                         }];

SpecBegin(ContentType)

describe(@"Content Type", ^{
    __block CMAClient* client;
    __block CMASpace* space;

    RECORD_TESTCASE

    beforeEach(^AsyncBlock {
        NSString* token = [ManagementSDKKeys new].managementAPIAccessToken;

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

    it(@"can be activated", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"foo" type:CDAFieldTypeDate] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.isPublished).to.equal(NO);

                                     [contentType publishWithSuccess:^{
                                         expect(contentType.sys[@"publishedCounter"]).equal(@1);
                                         expect(contentType.isPublished).to.equal(YES);

                                         [contentType unpublishWithSuccess:^{
                                             expect(contentType.isPublished).to.equal(NO);

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

    it(@"can be deactivated", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"foo" type:CDAFieldTypeDate] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();

                                     [contentType publishWithSuccess:^{
                                         expect(contentType.sys[@"publishedVersion"]).equal(@1);

                                         [contentType unpublishWithSuccess:^{
                                             expect(contentType.sys[@"publishedVersion"]).to.beNil();

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

    it(@"can be created", ^AsyncBlock {
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
                                     expect(contentType).toNot.beNil();
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

    it(@"can be created with an array field of symbols", ^AsyncBlock {
        ArrayTestWithItemType(CDAFieldTypeSymbol);
    });

    it(@"can be created with an array field of entries", ^AsyncBlock {
        ArrayTestWithItemType(CDAFieldTypeEntry);
    });

    it(@"can be created with an array field of assets", ^AsyncBlock {
        ArrayTestWithItemType(CDAFieldTypeAsset);
    });

    it(@"can be created with a link to an entry", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"Link" type:CDAFieldTypeEntry] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(1);

                                     [contentType publishWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(1);
                                         expect(contentType.sys[@"publishedVersion"]).equal(@1);

                                         [contentType unpublishWithSuccess:^{
                                             expect(contentType).toNot.beNil();
                                             expect(contentType.fields.count).equal(1);
                                             expect(contentType.sys[@"publishedVersion"]).to.beNil();

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

    it(@"can be deleted", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:nil
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(0);

                                     [contentType deleteWithSuccess:^{
                                         if (![BBURecordingHelper sharedHelper].isReplaying) {
                                             [NSThread sleepForTimeInterval:2.0];
                                         }

                                         [space fetchContentTypeWithIdentifier:contentType.identifier
                                                                       success:^(CDAResponse *response,
                                                                                 CMAContentType *ct) {
                                                                           dispatch_sync(dispatch_get_main_queue(), ^{
                                                                               XCTFail(@"Should not succeed.");
                                                                           });

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

    it(@"does not change during update", ^AsyncBlock {
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
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(8);

                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
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
                                 } failure:^(CDAResponse *response, NSError *error) {
                                     XCTFail(@"Error: %@", error);

                                     done();
                                 }];
    });

    it(@"can add a new field during update", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"field" type:CDAFieldTypeText] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(1);

                                     [contentType addFieldWithName:@"anotherField"
                                                              type:CDAFieldTypeNumber];
                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(2);

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
    });

    it(@"can add a new field created manually", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"field" type:CDAFieldTypeText] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(1);

                                     CMAField* field = [CMAField fieldWithName:@"anotherField"
                                                                          type:CDAFieldTypeNumber];
                                     [contentType addField:field];

                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(2);

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
    });

    it(@"can delete an existing field during update", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"field1" type:CDAFieldTypeText],
                                            [CMAField fieldWithName:@"field2" type:CDAFieldTypeText],
                                            [CMAField fieldWithName:@"field3" type:CDAFieldTypeText] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(3);

                                     NSString* identifier = [contentType.fields.firstObject identifier];
                                     [contentType deleteFieldWithIdentifier:identifier];
                                     [contentType deleteField:contentType.fields.firstObject];

                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(1);

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
    });

    it(@"can update the name of an existing field during update", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"field1" type:CDAFieldTypeText]]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(1);
                                     expect([contentType.fields.firstObject name]).equal(@"field1");

                                     [contentType updateName:@"foobar" ofFieldWithIdentifier:@"field1"];
                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(1);
                                         expect([contentType.fields.firstObject identifier]).equal(@"field1");
                                         expect([contentType.fields.firstObject name]).equal(@"foobar");

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
    });

    it(@"can update the type of an existing field during update", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"field1" type:CDAFieldTypeText]]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(1);

                                     __block CMAField* field = contentType.fields.firstObject;
                                     expect(field.type).equal(CDAFieldTypeText);

                                     [contentType updateType:CDAFieldTypeDate ofFieldWithIdentifier:@"field1"];
                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(1);

                                         field = contentType.fields.firstObject;
                                         expect(field.identifier).equal(@"field1");
                                         expect(field.type).equal(CDAFieldTypeDate);

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
    });

    it(@"can change name during update", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"name"
                                  fields:nil
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.name).to.equal(@"name");

                                     contentType.name = @"changed name";
                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.name).to.equal(@"changed name");

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
    });

    it(@"can change description during update", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"name"
                                  fields:nil
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.userDescription).to.beNil();

                                     contentType.userDescription = @"changed description";
                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.userDescription).to.equal(@"changed description");

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
    });

    it(@"does not allow to add two fields with the same name", ^AsyncBlock {
        NSAssert(space, @"Test space could not be found.");
        [space createContentTypeWithName:@"foobar"
                                  fields:@[ [CMAField fieldWithName:@"field" type:CDAFieldTypeText] ]
                                 success:^(CDAResponse *response, CMAContentType *contentType) {
                                     expect(contentType).toNot.beNil();
                                     expect(contentType.fields.count).equal(1);

                                     [contentType addFieldWithName:@"field" type:CDAFieldTypeNumber];
                                     [contentType updateWithSuccess:^{
                                         expect(contentType).toNot.beNil();
                                         expect(contentType.fields.count).equal(1);

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
    });
});

SpecEnd
