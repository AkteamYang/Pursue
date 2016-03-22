//
//  AKTLayoutReferenceObj.h
//  AKTLayoutDemo
//
//  Created by YaHaoo on 16/1/29.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKTLayoutReferenceObj.h"

//--------------# Macro #--------------
#define kAKTLayoutAttributeItemCapacity 20
#define kAKTLayoutAttributeItemTypeCapacity 20
//--------------# E.n.d #--------------#>Macro

//--------------------Structs statement & globle variables--------------------
// AKTLayoutAttributeItemType
typedef NS_ENUM(NSInteger, AKTLayoutAttributeItemType) {
    AKTLayoutAttributeItemType_Top,
    AKTLayoutAttributeItemType_Left,
    AKTLayoutAttributeItemType_Bottom,
    AKTLayoutAttributeItemType_Right,
    AKTLayoutAttributeItemType_Width,
    AKTLayoutAttributeItemType_Height,
    AKTLayoutAttributeItemType_WHRatio,
    AKTLayoutAttributeItemType_CenterX,
    AKTLayoutAttributeItemType_CenterY,
    AKTLayoutAttributeItemType_CenterXY
};

typedef struct {
    AKTLayoutAttributeItemType layoutTypeArray[kAKTLayoutAttributeItemTypeCapacity];
    int itemTypeCount;
    AKTLayoutReferenceObjInfo referenceObj;
}AKTLayoutAttributeItemInfo;

typedef AKTLayoutAttributeItemInfo *AKTLayoutAttributeItemInfoRef;
//-------------------- E.n.d -------------------->Structs statement & globle variables

/*
 * AKTLayoutAttributeItem
 * defined a part of layout attributes, such as the priority of the attribute(the lower the value, the higher the priority),the attribute type and the contant
 */
@interface AKTLayoutAttributeItem : NSObject
@property (assign, nonatomic) AKTLayoutAttributeItemInfoRef infoRef;


/*
 * Return a singleton object
 */
+ (id)sharedInstanceWithInfoRef:(AKTLayoutAttributeItemInfoRef)infoRef;

/*
 * Return an initializedInfo
 */
+ (AKTLayoutAttributeItemInfo)initializedInfo;

// Configure layout attribute item
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

// End set layout attribute item and set reference object
- (AKTLayoutReferenceObj *(^)(UIView *view))equalToView;
- (AKTLayoutReferenceObj *(^)(CGFloat constant))equalToConstant;
//- (AKTLayoutReferenceObj *(^)(id obj))equalTo;

/*
 * Return origin*multiple+offset
 */
CGFloat calculate(CGFloat origin, CGFloat multiple, CGFloat offset);
@end
