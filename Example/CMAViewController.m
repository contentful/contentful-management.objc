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

@property (nonatomic) NSArray* spaces;

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
     fetchAllSpacesWithSuccess:^(CDAResponse *response, CDAArray *array) {
         self.spaces = [array.items sortedArrayUsingComparator:^NSComparisonResult(CMASpace* space1,
                                                                                   CMASpace* space2) {
             return [space1.name compare:space2.name];
         }];

         [self.tableView reloadData];
     } failure:^(CDAResponse *response, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)
                                                            forIndexPath:indexPath];

    CMASpace* space = self.spaces[indexPath.row];
    cell.textLabel.text = space.name;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.spaces.count;
}

@end
