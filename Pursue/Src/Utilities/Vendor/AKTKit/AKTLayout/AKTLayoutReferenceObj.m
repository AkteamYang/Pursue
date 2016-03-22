//
//  AKTLayoutReferenceObj.m
//  AKTLayoutDemo
//
//  Created by YaHaoo on 16/1/29.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTLayoutReferenceObj.h"

//--------------------Structs statement & globle variables--------------------
static id aktLayoutReferenceObj_Singleton = nil;
//-------------------- E.n.d -------------------->Structs statement & globle variables

/*
 * AKTLayoutReferenceObj contains position reference information, such as the relative position of a view ,the offset or multiple. Simply summarized as follows:
 result = referenceObj * referenceMultiple + referenceOffset.
 */
@implementation AKTLayoutReferenceObj
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Return a singleton object
 */
+ (id)sharedInstanceWithInfoRef:(AKTLayoutReferenceObjInfoRef)infoRef {
    if (aktLayoutReferenceObj_Singleton == nil) {
        aktLayoutReferenceObj_Singleton = [AKTLayoutReferenceObj new];
    }
    ((AKTLayoutReferenceObj *)aktLayoutReferenceObj_Singleton).infoRef = infoRef;
    return aktLayoutReferenceObj_Singleton;
}

/*
 * Return an initializedInfo
 */
+ (AKTLayoutReferenceObjInfo)initializedInfo {
    AKTLayoutReferenceObjInfo info = {
        .referenceValidate = false,
        .referenceMultiple = 1.0f,
        .referenceOffset = 0.0f,
        .referenceInsert = {FLT_MAX, FLT_MAX, FLT_MAX, FLT_MAX}
    };
    return info;
}

#pragma mark - universal methods
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Multiple and offset
 */
- (AKTLayoutReferenceObj *(^)(CGFloat obj))multiple {
    return ^ AKTLayoutReferenceObj *(CGFloat obj) {
        self.infoRef->referenceMultiple = obj;
        return self;
    };
}

- (AKTLayoutReferenceObj *(^)(CGFloat obj))offset {
    return ^ AKTLayoutReferenceObj * (CGFloat obj) {
        self.infoRef->referenceOffset = obj;
        return self;
    };
}

- (AKTLayoutReferenceObj *(^)(UIEdgeInsets inset))edgeInset {
    return ^ AKTLayoutReferenceObj * (UIEdgeInsets inset) {
        self.infoRef->referenceInsert = (UIEdgeInsets){
            inset.top,
            inset.left,
            inset.bottom,
            inset.right
        };
        return self;
    };
}
@end

