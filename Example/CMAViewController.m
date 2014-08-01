//
//  CMAViewController.m
//  ManagementSDK
//
//  Created by Boris Bügling on 07/14/2014.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <ContentfulManagementAPI/ContentfulManagementAPI.h>

#import "CMAViewController.h"

@interface CMAViewController ()

@property (nonatomic, copy) NSArray* spaces;

@end

#pragma mark -

@implementation CMAViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Management API Test", nil);

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass(self.class)];

    NSString* token = [[[NSProcessInfo processInfo] environment]
                       valueForKey:@"CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN"];

    [[[CMAClient alloc] initWithAccessToken:token]
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
     fetchAllSpacesWithSuccess:^(CDAResponse *response, CDAArray *array) {
#pragma clang diagnostic pop
         self.spaces = [array.items sortedArrayUsingComparator:^NSComparisonResult(CMASpace* space1,
                                                                                   CMASpace* space2) {
             return [space1.name compare:space2.name];
         }];

         [self.tableView reloadData];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
     } failure:^(CDAResponse *response, NSError *error) {
#pragma clang diagnostic pop
         NSLog(@"Error: %@", error);
     }];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)
                                                            forIndexPath:indexPath];

    CMASpace* space = self.spaces[(NSUInteger)indexPath.row];
    cell.textLabel.text = space.name;

    return cell;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#pragma clang diagnostic pop
    return (NSInteger)self.spaces.count;
}

@end
