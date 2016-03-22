//
//  UIView+QuickLayout.h
//  AKTeamUikitExtension
//
//  Created by YaHaoo on 15/9/8.
//  Copyright (c) 2015年 CoolHear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTLayoutAttribute.h"

//--------------------Structs statement, globle variables...--------------------
// QuickLayoutConstraintType
typedef NS_ENUM(NSInteger, QuickLayoutConstraintType) {
    QuickLayoutConstraintAlignTo_Top,
    QuickLayoutConstraintAlignTo_Left,
    QuickLayoutConstraintAlignTo_Bottom,
    QuickLayoutConstraintAlignTo_Right,
    
    QuickLayoutConstraintSpaceTo_Top,
    QuickLayoutConstraintSpaceTo_Left,
    QuickLayoutConstraintSpaceTo_Bottom,
    QuickLayoutConstraintSpaceTo_Right,
    
    QuickLayoutConstraintAlign_Vertical,
    QuickLayoutConstraintAlign_Horizontal,
    
    QuickLayoutConstraintWidth,
    QuickLayoutConstraintHeight,
    QuickLayoutConstraintRateW_H
};
struct AKTTestStruct {
    struct AKTTestStruct (*equalToConstant)(float constant);
};
typedef struct AKTTestStruct AKTTest;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

/*
 * AktLayout
 */
@interface UIView (AKTLayout)
///< Properties related to frame
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
///< The width or height will be adaptive if we set the corresponding value to YES. But if all of the two values were setted to YES or NO the view wouldn't be adaptive.
@property (assign, nonatomic) BOOL adaptiveWidth;
@property (assign, nonatomic) BOOL adaptiveHeight;

- (NSNumber *)akt_top;
- (NSNumber *)akt_left;
- (NSNumber *)akt_bottom;
- (NSNumber *)akt_right;
- (NSNumber *)akt_width;
- (NSNumber *)akt_height;
- (NSNumber *)akt_whRatio;

/*
 *  Layout
 *
 *  @param type          layout type
 *  @param referenceView reference view
 *  @param offset        offset
 */
- (void)AKTQuickLayoutWithType:(QuickLayoutConstraintType)type referenceView:(UIView *)referenceView offset:(CGFloat)offset;

/*
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 */
- (void)aktLayout:(void(^)(AKTLayoutAttribute *layout))layout;

/*
 * The method："aktLayoutUpdate" will be called when the view's frame size changed. We can insert our subview layout code into the method, so that the UI can adaptive change
 * Subview layout code was recommended to insert into the method
 */
- (void)aktLayoutUpdate;
@end
