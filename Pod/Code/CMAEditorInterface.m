//
//  CMAEditorInterface.m
//  Pods
//
//  Created by Boris Bügling on 11/07/16.
//

#import "CDAResource+Private.h"
#import "CMAEditorInterface.h"

@interface CMAEditorInterface ()

@property (nonatomic, copy) NSArray* controls;

@end

#pragma mark -

@implementation CMAEditorInterface

+(NSString *)CDAType {
    return @"EditorInterface";
}

#pragma mark -

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ '%@': %@", self.class.CDAType, self.controls];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
                 client:(CDAClient *)client
  localizationAvailable:(BOOL)localizationAvailable {
    self = [super initWithDictionary:dictionary
                              client:client
               localizationAvailable:localizationAvailable];
    if (self) {
        self.controls = dictionary[@"controls"];
    }
    return self;
}

@end
