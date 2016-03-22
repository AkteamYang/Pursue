//
//  PNavigationBar.m
//  Pursue
//
//  Created by YaHaoo on 16/2/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PNavigationBar.h"
#import "AKTKit.h"

@implementation PNavigationBar
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.width = mAKT_SCREENWITTH;
        self.height = 64;
        [self initUI];
    }
    return self;
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    
}
@end
