//
//  PCTableViewCell.m
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PCTableViewCell.h"
#import "AKTKit.h"

@implementation PCTableViewCell
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
#pragma mark - super methods
//|---------------------------------------------------------------------------------------------------------------------------
- (void)aktLayoutUpdate {

    
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup Style
    self.backgroundColor = mAKT_Color_Clear;
    
    // Setup UI items

}
#pragma mark - universal methods
//|---------------------------------------------------------------------------------------------------------------------------
- (void)setData:(PChatObj *)data {

}
@end
