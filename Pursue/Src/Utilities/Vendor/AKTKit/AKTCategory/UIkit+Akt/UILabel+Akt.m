//
//  UILabel+Akt.m
//  Pursue
//
//  Created by YaHaoo on 16/2/26.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//
// import-<frameworks.h>
#import <objc/runtime.h>
// import-"models.h"
// import-"views.h"
#import "UILabel+Akt.h"
#import "UIView+AKTLayout.h"
#import "AKTPublic.h"

@implementation UILabel (Akt)
#pragma mark - super method
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Do something before initialization.
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Exchange "setText:" to "aktText:"
        [UILabel swizzleClass:[UILabel class] fromMethod:@selector(setText:) toMethod:@selector(aktText:)];
    });
}
#pragma mark - property settings
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * The method was exchaged to method "setText:" in the initialization of a label. So when we call "aktText:" in actually calling "setText:".
 */
- (void)aktText:(NSString *)text {
    // Set label's text
    [self aktText:text];
    
    // Setting all of them to NO means that the frame cann't change, just return.
    if (self.adaptiveHeight == NO && self.adaptiveWidth == NO) {
        return;
    }
    
    // If all of values of them are YES we'll set the view's height to single line height and adaptiveHeight to NO by default.
    if (self.adaptiveWidth == YES && self.adaptiveHeight == YES) {
        self.adaptiveHeight = NO;
        CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
        // If self.frame.size is equal to size, just return.
        if (mAKT_EQ(self.width, size.width) && mAKT_EQ(self.height, size.height)) {
            return;
        }
        self.height = size.height;
        self.width = size.width;
        return;
    }
    
    // Set lable's bounds adaptively base on the content
    if (self.adaptiveHeight) {
        CGRect rec = [text boundingRectWithSize:(CGSizeMake(self.width, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil];
        // If self.height is equal to CGRectGetHeight(rec), just return.
        if (mAKT_EQ(self.height, CGRectGetHeight(rec))) {
            return;
        }
        self.height = CGRectGetHeight(rec);
    }else if (self.adaptiveWidth) {
        CGRect rec = [text boundingRectWithSize:(CGSizeMake(9999, self.height)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil];
        self.width = CGRectGetWidth(rec);
    }
    
    // Update aktLayout
    [self.superview aktLayoutUpdate];
}
#pragma mark - runtime
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Method swizzle
 * Exchange origne method to a new method
 */
+ (BOOL)swizzleClass:(Class)cls fromMethod:(SEL)origneSelector toMethod:(SEL)newSelector {
    // Safty check
    if (!(cls && origneSelector && newSelector)) {
        return NO;
    }
    Method origneMethod = class_getInstanceMethod(cls, origneSelector);
    Method newMethod = class_getInstanceMethod(cls, newSelector);
    // If we can't get the values of newMethod and origneMethod, return NO for exit.
    if (!(origneMethod && newMethod)) {
        return NO;
    }
    // Exchange method.
//    method_exchangeImplementations(origneMethod, newMethod);
    IMP origneImp = class_getMethodImplementation(cls, origneSelector);
    IMP newImp = class_getMethodImplementation(cls, newSelector);
    class_replaceMethod(cls, origneSelector, newImp, method_getTypeEncoding(newMethod));
    class_replaceMethod(cls, newSelector, origneImp, method_getTypeEncoding(origneMethod));
    return YES;
}
@end
