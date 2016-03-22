//
//  AKTLayoutAttribute.h
//  AKTLayoutDemo
//
//  Created by YaHaoo on 16/1/29.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKTLayoutAttributeItem.h"

//--------------------Structs statement & globle variables--------------------
typedef struct {
    AKTLayoutAttributeItemInfo attributeItems[kAKTLayoutAttributeItemCapacity];
    int itemCount;
}AKTLayoutAttributeInfo;

typedef AKTLayoutAttributeInfo *AKTLayoutAttributeInfoRef;
//-------------------- E.n.d -------------------->Structs statement & globle variables

/*
 * AKTLayoutAttribute
 * contains attributeItems, we can layout the view with them
 */
@interface AKTLayoutAttribute : NSObject
@property (strong, nonatomic) NSString *name;///< When an error occurs, we can print the error and the name. It's very useful to mark the error point. So we strongly recommend setting name
@property (weak, nonatomic) UIView *bindView;///< The view which need to layout
@property (assign, nonatomic) AKTLayoutAttributeInfoRef infoRef;

/*
 * Return a singleton object
 */
+ (id)sharedInstanceWithInfoRef:(AKTLayoutAttributeInfoRef)infoRef;

/*
 * Calculate layout with the infor from the attribute items, return CGRect
 */
- (CGRect)calculateAttribute;

/*
 * Create layout attribute item
 */
- (AKTLayoutAttributeItem *)top;
- (AKTLayoutAttributeItem *)left;
- (AKTLayoutAttributeItem *)bottom;
- (AKTLayoutAttributeItem *)right;
- (AKTLayoutAttributeItem *)width;
- (AKTLayoutAttributeItem *)height;
- (AKTLayoutAttributeItem *)whRatio;
- (AKTLayoutAttributeItem *)centerX;
- (AKTLayoutAttributeItem *)centerY;
- (AKTLayoutAttributeItem *)centerXY;
- (AKTLayoutAttributeItem *)edge;
@end

