//
//  PMessageTableViewCell.m
//  Pursue
//
//  Created by YaHaoo on 16/2/23.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "PMessageTableViewCell.h"
#import "AKTKit.h"

@interface PMessageTableViewCell ()
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *time;
@end
@implementation PMessageTableViewCell
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
    // Set subview's frame
    // Container
    [self.container aktLayout:^(AKTLayoutAttribute *layout) {
        layout.edge.equalToView(self).edgeInset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Avatar
    [self.avatar aktLayout:^(AKTLayoutAttribute *layout) {
        layout.centerY.equalToView(self.container);
        layout.top.left.equalToView(self.container).offset(10);
        layout.whRatio.equalToConstant(1);
    }];
    // Line
    [self.line aktLayout:^(AKTLayoutAttribute *layout) {
        layout.left.equalToConstant(self.avatar.akt_right.floatValue).offset(10);
        layout.bottom.right.equalToView(self);
        layout.height.equalToConstant(.5);
    }];
    self.avatar.layer.cornerRadius = self.avatar.width/2;
    // Name
    CGSize size;
//    self.name.width = size.width;
//    self.name.height = size.height;
    [self.name aktLayout:^(AKTLayoutAttribute *layout) {
        layout.left.equalToView(self.line);
        layout.top.equalToView(self.avatar).offset(5);
//#warning akt bug as follows
//        self.name.width = size.width;
//        self.name.height = size.height;
//        layout.height.equalToConstant(size.height);
    }];
//    self.name.text = self.name.text;
    // Title
    size = [self.title.text sizeWithAttributes:@{NSFontAttributeName:self.title.font}];
    self.title.width = size.width;
    self.title.height = size.height;
    [self.title aktLayout:^(AKTLayoutAttribute *layout) {
        layout.left.equalToView(self.name);
        layout.bottom.equalToView(self.avatar).offset(-5);
    }];
    // Time
    size = [self.time.text sizeWithAttributes:@{NSFontAttributeName:self.time.font}];
    self.time.width = size.width;
    self.time.height = size.height;
    [self.time aktLayout:^(AKTLayoutAttribute *layout) {
        layout.right.equalToView(self.container).offset(-10);
        layout.top.equalToView(self.name);
    }];
}

#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    // Setup Style
    self.backgroundColor = mAKT_Color_Clear;
    
    // Setup UI items
    _container = self.container;
    _line = self.line;
    _avatar = self.avatar;
    _name = self.name;
    _title = self.title;
    _time = self.time;
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
- (UIView *)container {
    if (_container == nil) {
        _container = [UIView new];
        [self addSubview:_container];
//        _container.layer.cornerRadius = 5;
//        _container.layer.masksToBounds = YES;
//        _container.layer.borderColor = mAKT_Color_LightGray.CGColor;
//        _container.layer.borderWidth = .5;
    }
    return _container;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [UIView new];
        [self addSubview:_line];
        _line.backgroundColor = mAKT_COLOR_Color(230, 230, 230, 1);
    }
    return _line;
}

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [UIImageView new];
        [self.container addSubview:_avatar];
        _avatar.layer.masksToBounds = YES;
//#ifdef DEBUG
        _avatar.image = mAKT_Image(@"P_Avatar4");
        _avatar.backgroundColor = mAKT_Color_LightGray;
//#endif
    }
    return _avatar;
}

- (UILabel *)name {
    if (_name == nil) {
        _name = [UILabel new];
        [self.container addSubview:_name];
        _name.font = mAKT_Font_SSS;
//        _name.textColor = mAKT_T_XXXX;
//#ifdef DEBUG
        _name.text = @"一干为尽";
//#endif
    }
    return _name;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [UILabel new];
        [self.container addSubview:_title];
        _title.textColor = mAKT_Color_Text_XXX;
        _title.font = mAKT_Font_SSSS;
//#ifdef DEBUG
        _title.text = @"谁能和我说说引力波是怎么回事？";
//#endif
    }
    return _title;
}

- (UILabel *)time {
    if (_time == nil) {
        _time = [UILabel new];
        [self.container addSubview:_time];
        _time.font = mAKT_Font_SSSSS;
        _time.textColor = mAKT_Color_Text_XX;
//#ifdef DEBUG
        _time.text = @"07:50";
//#endif
    }
    return _time;
}

-(void)setData:(PMessageObj *)data
{
    _name.text = data.name;
    _title.text =data.title;
    _time.text = data.time;
    static int i = 0;
    i++;
    NSString *str = [NSString stringWithFormat:@"P_Avatar%d", i%6+1];
    _avatar.image = mAKT_Image(str);
}
@end
