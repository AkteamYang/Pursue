//
//  PMessageTableView.m
//  Pursue
//
//  Created by YaHaoo on 16/2/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//
// import-<frameworks.h>

// import-"models.h"
#import "PMessageObj.h"
#import "PSendMessageObj.h"
// import-"views & controllers.h"
#import "PMessageTableView.h"
#import "PMessageTableViewCell.h"
#import "PChatViewController.h"

//--------------------Structs statement, globle variables...--------------------
static NSString * const reuseIdentifier = @"cell";
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface PMessageTableView ()
@property (strong, nonatomic) NSMutableArray *data;
@end
@implementation PMessageTableView
{
    NSDateFormatter *formatter_;
}
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        formatter_ = [[NSDateFormatter alloc] init];
        [formatter_ setDateStyle:NSDateFormatterMediumStyle];
        [formatter_ setTimeStyle:NSDateFormatterShortStyle];
        [formatter_ setDateFormat:@"HH:mm"];
        [self initUI];
    }
    return self;
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    [self registerClass:[PMessageTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
}

/*
 * Reload tableView with data;
 */
- (void)reloadData:(NSMutableArray *)data {
    self.data = data;
    [self reloadData];
}
#pragma mark - delegate
//|---------------------------------------------------------------------------------------------------------------------------
#pragma mark - tableview datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
//    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSendMessageObj *obj = _data[indexPath.row];
    PMessageObj *messobj = [[PMessageObj alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[obj.time integerValue]];
    NSLog(@"confromTimesp = %@",confromTimesp);
    NSString *confromTimespStr = [formatter_ stringFromDate:confromTimesp];
   NSLog(@"confromTimespStr = %@",confromTimespStr);
    messobj.name = obj.uuid;
    messobj.title = obj.message;
    messobj.time = confromTimespStr;
    PMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setData:messobj];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = (id)self.nextResponder.nextResponder;
    [vc.navigationController pushViewController:[PChatViewController new] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
@end
