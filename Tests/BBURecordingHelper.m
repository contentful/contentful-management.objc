//
//  BBURecordingHelper.m
//  ManagementSDK
//
//  Created by Boris Bügling on 30/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <CCLRequestReplay/CCLRequestRecordProtocol.h>
#import <CCLRequestReplay/CCLRequestReplayProtocol.h>

#import "BBURecordingHelper.h"

@interface BBURecordingHelper ()

@property (nonatomic) CCLRequestReplayManager* manager;

@end

#pragma mark -

@implementation BBURecordingHelper

+(NSString*)recordingPathForTestCase:(Class)testCase {
    NSString* path = [[NSBundle bundleForClass:testCase] bundlePath];
    path = [path stringByAppendingPathComponent:NSStringFromClass(testCase)];
    return [path stringByAppendingPathExtension:@"recording"];
}

+(instancetype)sharedHelper {
    static BBURecordingHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [self new];
    });
    return sharedHelper;
}

#pragma mark -

-(void)loadRecordingsForTestCase:(Class)testCase {
    NSString* recordingPath = [[self class] recordingPathForTestCase:testCase];

    if ([[NSFileManager defaultManager] fileExistsAtPath:recordingPath]) {
        self.manager = [NSKeyedUnarchiver unarchiveObjectWithFile:recordingPath];

        [self.manager replay];
    } else {
        self.manager = [CCLRequestReplayManager new];
        
        [self.manager record];
    }
}

-(void)storeRecordingsForTestCase:(Class)testCase {
    [self.manager stopReplay];
    [self.manager stopRecording];

    [NSKeyedArchiver archiveRootObject:self.manager
                                toFile:[[self class] recordingPathForTestCase:testCase]];

    self.manager = nil;
}

@end
