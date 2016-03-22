//
//  AKTLayoutReferenceObj.h
//  AKTLayoutDemo
//
//  Created by YaHaoo on 16/1/29.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//--------------------Structs statement & globle variables--------------------
typedef NS_ENUM(NSInteger, AKTRefenceType){
    AKTRefenceType_View,
    AKTRefenceType_Constant,
    AKTRefenceType_Other
};

/*
 * AKTLayoutReferenceObjInfo
 */
typedef struct {
    bool referenceValidate;
    AKTRefenceType referenceType;
    void *referenceView;
    float referenceConstant;
    float referenceMultiple;
    float referenceOffset;
    UIEdgeInsets referenceInsert;
}AKTLayoutReferenceObjInfo;

typedef AKTLayoutReferenceObjInfo *AKTLayoutReferenceObjInfoRef;
//-------------------- E.n.d -------------------->Structs statement & globle variables

/*
 * AKTLayoutReferenceObj contains position reference information, such as the relative position of a view ,the offset or multiple. Simply summarized as follows:
 result = referenceObj * referenceMultiple + referenceOffset.
 */
@interface AKTLayoutReferenceObj : NSObject
@property (assign, nonatomic) AKTLayoutReferenceObjInfoRef infoRef;

/*
 * Return a singleton object
 */
+ (id)sharedInstanceWithInfoRef:(AKTLayoutReferenceObjInfoRef)infoRef;

/*
 * Return an initializedInfo
 */
+ (AKTLayoutReferenceObjInfo)initializedInfo;

/*
 * Multiple and offset
 */
- (AKTLayoutReferenceObj *(^)(CGFloat obj))multiple;
- (AKTLayoutReferenceObj *(^)(CGFloat obj))offset;
- (AKTLayoutReferenceObj *(^)(UIEdgeInsets inset))edgeInset;
@end

