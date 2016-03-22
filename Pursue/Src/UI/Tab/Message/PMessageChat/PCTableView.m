//
//  PCTableViewController.m
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PCTableView.h"
#import "AKTKit.h"
#import "PCTableViewCell.h"

//--------------------Structs statement, globle variables...--------------------
static NSString * const reuseIdentifier = @"cell";
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface PCTableView ()
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *tableHeight;
@end
@implementation PCTableView
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self initUI];
    }
    return self;
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup self
    [self registerClass:[PCTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
//    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
}
#pragma mark - tableview datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return _data.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
