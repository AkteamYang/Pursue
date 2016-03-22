//
//  PMessageTableViewCell.h
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMessageObj.h"

@interface PMessageTableViewCell : UITableViewCell
/*
 * Set data to cell for displaying
 */
- (void)setData:(PMessageObj *)data;
@end
