//
//  BBURecordingHelper.h
//  ManagementSDK
//
//  Created by Boris Bügling on 30/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RECORD_TESTCASE     beforeAll(^{ \
[[BBURecordingHelper sharedHelper] loadRecordingsForTestCase:[self class]]; \
}); \
\
afterAll(^{ \
[[BBURecordingHelper sharedHelper] storeRecordingsForTestCase:[self class]]; \
});

@interface BBURecordingHelper : NSObject

+(instancetype)sharedHelper;

@property (nonatomic, readonly, getter = isReplaying) BOOL replaying;

-(void)loadRecordingsForTestCase:(Class)testCase;
-(void)storeRecordingsForTestCase:(Class)testCase;

@end
