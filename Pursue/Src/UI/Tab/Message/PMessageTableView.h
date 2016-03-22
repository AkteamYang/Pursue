//
//  PMessageTableView.h
//  Pursue
//
//  Created by YaHaoo on 16/2/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMessageTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
/*
 * Reload tableView with data;
 */
- (void)reloadData:(NSMutableArray *)data;
@end
