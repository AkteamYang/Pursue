//
//  UIView+QuickLayout.m
//  AKTeamUikitExtension
//
//  Created by YaHaoo on 15/9/8.
//  Copyright (c) 2015年 CoolHear. All rights reserved.
//

#import "UIView+AKTLayout.h"
#import "AKTPublic.h"
#import <objc/runtime.h>

//--------------------Structs statement, globle variables...--------------------
static char * const AKT_ADAPTIVE_WIDTH = "AKT_ADAPTIVE_WIDTH";
static char * const AKT_ADAPTIVE_HEIGHT = "AKT_ADAPTIVE_HEIGHT";
static char * const kLastFrame;
//-------------------- E.n.d -------------------->Structs statement & globle variables

@interface UIView()
@end

@implementation UIView (AKTLayout)
#pragma mark - properties
/**
 *Properties related to frame
 */

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

/*
 * AdaptiveWidth getter
 */
- (BOOL)adaptiveWidth {
    NSNumber *b = objc_getAssociatedObject(self, AKT_ADAPTIVE_WIDTH);
    if (b) {
        return [b boolValue];
    }else{
        return YES;
    }
}

/*
 * AdaptiveWidth setter
 */
- (void)setAdaptiveWidth:(BOOL)adaptiveWidth {
    objc_setAssociatedObject(self, AKT_ADAPTIVE_WIDTH, @(adaptiveWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/*
 * AdaptiveHeight getter
 */
- (BOOL)adaptiveHeight {
    NSNumber *b = objc_getAssociatedObject(self, AKT_ADAPTIVE_HEIGHT);
    if (b) {
        return [b boolValue];
    }else{
        return YES;
    }
}

/*
 * AdaptiveHeight setter
 */
- (void)setAdaptiveHeight:(BOOL)adaptiveHeight {
    objc_setAssociatedObject(self, AKT_ADAPTIVE_HEIGHT, @(adaptiveHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - layout methods
- (NSNumber *)akt_top {
    return @(self.y);
}

- (NSNumber *)akt_left {
    return @(self.x);
}

- (NSNumber *)akt_bottom {
    return @(self.y + self.height);
}

- (NSNumber *)akt_right {
    return @(self.x + self.width);
}

- (NSNumber *)akt_width {
    return @(self.width);
}

- (NSNumber *)akt_height {
    return @(self.height);
}

- (NSNumber *)akt_whRatio {
    return @(self.width/self.height);
}

/**
 *  Layout
 *
 *  @param type          layout type
 *  @param referenceView reference view
 *  @param offset        offset
 */
- (void)AKTQuickLayoutWithType:(QuickLayoutConstraintType)type referenceView:(UIView *)referenceView offset:(CGFloat)offset {
    switch (type) {
        case QuickLayoutConstraintAlignTo_Top:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset;
            }else{
                self.y = offset;
            }
            break;
        case QuickLayoutConstraintAlignTo_Left:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset;
            }else{
                self.x = offset;
            }
            break;
        case QuickLayoutConstraintAlignTo_Bottom:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + referenceView.height + offset - self.height;
            }else{
                self.y = offset + referenceView.height - self.height;
            }
            break;
        case QuickLayoutConstraintAlignTo_Right:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + referenceView.width + offset - self.width;
            }else{
                self.x = offset + referenceView.width - self.width;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Top:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset - self.height;
            }else{
                self.y = offset - self.height;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Left:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset - self.width;
            }else{
                self.x = offset - self.width;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Bottom:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset + referenceView.height;
            }else{
                self.y = offset + referenceView.height;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Right:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset + referenceView.width;
            }else{
                self.x = offset + referenceView.width;
            }
            break;
        case QuickLayoutConstraintAlign_Horizontal:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset + referenceView.height/2-self.height/2;
            }else{
                self.y = offset + referenceView.height/2-self.height/2;
            }
            break;
        case QuickLayoutConstraintAlign_Vertical:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset + referenceView.width/2-self.width/2;
            }else{
                self.x = offset + referenceView.width/2-self.width/2;
            }
            break;
        default:
            break;
    }
}

/*
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 * Notice！If one view call the method for many times the last call may override the previous one. Including layout attribute configuration and view's adapting properties.
 */
- (void)aktLayout:(void(^)(AKTLayoutAttribute *layout))layout
{
    // Whether the view is validate
    if (!self.superview) {
        NSLog(@"Your view or the referenceview should has a superview");
        return;
    }
    
    // Set layout items and reference object for the layout attribute
    AKTLayoutAttributeInfo info;
    info.itemCount = 0;
    AKTLayoutAttribute *attribute = [AKTLayoutAttribute sharedInstanceWithInfoRef:&info];
    // Set the view what the attribute effect on to the attribute. We call the view the bindView. Before setting the bindView we need initialize the view's adapting properties.
    objc_setAssociatedObject(self, AKT_ADAPTIVE_WIDTH, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, AKT_ADAPTIVE_HEIGHT, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    attribute.bindView = self;
    if (layout) {
        layout(attribute);
    }else{
        return;
    }
    // Calculate layout in priority order
    CGRect rect = [attribute calculateAttribute];
    
    // Set frame
    self.frame = rect;
}

#pragma mark - update frame
/*
 * The method："aktLayoutUpdate" will be called when the view's frame size changed. We can insert our subview layout code into the method, so that the UI can adaptive change
 */
- (void)setLastFrame:(CGRect)lastFrame
{
    objc_setAssociatedObject(self, kLastFrame, [NSValue valueWithCGRect:lastFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)lastFrame
{
    NSValue *value = objc_getAssociatedObject(self, kLastFrame);
    return [value CGRectValue];
}

- (void)layoutSubviews {
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int widthOld = self.lastFrame.size.width;
    int heightOld = self.lastFrame.size.height;
    if (width == widthOld && height == heightOld) {
        nil;
    }else{
        self.lastFrame = self.frame;
        [self aktLayoutUpdate];
    }
}

- (void)aktLayoutUpdate
{
    
}
@end
