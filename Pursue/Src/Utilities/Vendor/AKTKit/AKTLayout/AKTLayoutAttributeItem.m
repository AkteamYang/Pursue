//
//  AKTLayoutReferenceObj.m
//  AKTLayoutDemo
//
//  Created by YaHaoo on 16/1/29.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTLayoutAttributeItem.h"
#import "AKTLayoutReferenceObj.h"

//--------------------Structs statement & globle variables--------------------
static id aktLayoutAttributeItem_Singleton = nil;
//-------------------- E.n.d -------------------->Structs statement & globle variables

/*
 * AKTLayoutAttributeItem
 * a layout information container ,the information was stored in a mutable dictionary and the information was classified by priority (the lower the value, the higher the priority)
 * the attribute type and the contant
 */
@interface AKTLayoutAttributeItem ()

@end

@implementation AKTLayoutAttributeItem
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Return a singleton object
 */
+ (id)sharedInstanceWithInfoRef:(AKTLayoutAttributeItemInfoRef)infoRef {
    if (aktLayoutAttributeItem_Singleton == nil) {
        aktLayoutAttributeItem_Singleton = [AKTLayoutAttributeItem new];
    }
    AKTLayoutAttributeItem *item = aktLayoutAttributeItem_Singleton;
    item.infoRef = infoRef;
    return item;
}

/*
 * Return an initializedInfo
 */
+ (AKTLayoutAttributeItemInfo)initializedInfo {
    AKTLayoutAttributeItemInfo info;
    info.itemTypeCount = 0;
    info.referenceObj = [AKTLayoutReferenceObj initializedInfo];
    return info;
}

#pragma mark - layout attribute item configures
/*
 * Add layout information to the attribute item
 * Priority of layout types
 * @1 Top, Left
 * @2 Bottom, Right
 * @3 Width, Height
 * @4 WHRatio : the ratio of width and height, if the ratio was set it will always work
 * @5 CenterX, CenterY
 * @6 CenterXY
 */
- (AKTLayoutAttributeItem *)top {
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_Top]? self:nil;
}

- (AKTLayoutAttributeItem *)left {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_Left]? self:nil;
}

- (AKTLayoutAttributeItem *)bottom {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_Bottom]? self:nil;
}

- (AKTLayoutAttributeItem *)right {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_Right]? self:nil;
}

- (AKTLayoutAttributeItem *)width {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_Width]? self:nil;
}

- (AKTLayoutAttributeItem *)height {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_Height]? self:nil;
}

- (AKTLayoutAttributeItem *)whRatio {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_WHRatio]? self:nil;
}

- (AKTLayoutAttributeItem *)centerX {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_CenterX]? self:nil;
}

- (AKTLayoutAttributeItem *)centerY {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_CenterY]? self:nil;
}

- (AKTLayoutAttributeItem *)centerXY {
    // Insert code here...
    return [self AddAttributeItemType:AKTLayoutAttributeItemType_CenterXY]? self:nil;
}

- (BOOL)AddAttributeItemType:(AKTLayoutAttributeItemType)type {
    // Check whether out of range
    if (self.infoRef->itemTypeCount==kAKTLayoutAttributeItemTypeCapacity) {
        NSLog(@"Out of the range of attributeItemTypeInfo array");
        return NO;
    }
    // Add itemType to itemInfo
    self.infoRef->layoutTypeArray[self.infoRef->itemTypeCount] = type;
    self.infoRef->itemTypeCount++;
    return YES;
}

/*
 * Create and add layout reference view
 */
- (AKTLayoutReferenceObj *(^)(UIView *view))equalToView {
    return ^ AKTLayoutReferenceObj *(UIView *view){
        // Add reference view
        self.infoRef->referenceObj.referenceValidate = true;
        self.infoRef->referenceObj.referenceType = AKTRefenceType_View;
        self.infoRef->referenceObj.referenceView = (__bridge void *)(view);
        AKTLayoutReferenceObj *refObj = [AKTLayoutReferenceObj sharedInstanceWithInfoRef:&self.infoRef->referenceObj];
        return refObj;
    };
}

/*
 * Create and add layout reference constant
 */
- (AKTLayoutReferenceObj *(^)(CGFloat constant))equalToConstant {
    return ^ AKTLayoutReferenceObj *(CGFloat constant){
        // Add reference constant
        self.infoRef->referenceObj.referenceValidate = true;
        self.infoRef->referenceObj.referenceType = AKTRefenceType_Constant;
        self.infoRef->referenceObj.referenceConstant = constant;
        AKTLayoutReferenceObj *refObj = [AKTLayoutReferenceObj sharedInstanceWithInfoRef:&self.infoRef->referenceObj];
        return refObj;
    };
}

/*
 * Return origin*multiple+offset
 */
CGFloat calculate(CGFloat origin, CGFloat multiple, CGFloat offset) {
    return origin*multiple+offset;
}
@end

