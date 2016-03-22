//
//  AKTLayoutAttribute.m
//  AKTLayoutDemo
//
//  Created by YaHaoo on 16/1/29.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTLayoutAttribute.h"
#import "UIView+AKTLayout.h"

//--------------# Macro #--------------
#define kAKTFloatMax (FLT_MAX-1)
//--------------# E.n.d #-------------->Macro

//--------------------Structs statement & globle variables--------------------
static id aktLayoutAttribute_Singleton = nil;

typedef struct {
    float top, left, bottom, right, width, height, whRatio, centerX, centerY;
}AKTLayoutParamInfo;

typedef AKTLayoutParamInfo *AKTLayoutParamInfoRef;

typedef struct {
    float x, y, width, height;
} AKTFrameInfo;
//-------------------- E.n.d -------------------->Structs statement & globle variables

/*
 * AKTLayoutAttribute
 * contains all of the attributeItems, we can layout the view with them
 */
@interface AKTLayoutAttribute()
AKTLayoutParamInfo initializedParamInfo();
@property (assign, nonatomic) AKTFrameInfo bindFrame;
@end

@implementation AKTLayoutAttribute
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Return a singleton object
 */
+ (id)sharedInstanceWithInfoRef:(AKTLayoutAttributeInfoRef)infoRef {
    if (aktLayoutAttribute_Singleton == nil) {
        aktLayoutAttribute_Singleton = [AKTLayoutAttribute new];
    }
    AKTLayoutAttribute *obj = aktLayoutAttribute_Singleton;
    obj.name = nil;
    obj.infoRef = infoRef;
    return obj;
}

#pragma mark properties
- (NSString *)name {
    if (_name == nil) {
        _name = [NSString stringWithFormat:@"%@:%p",NSStringFromClass(self.class),self];
    }
    return _name;
}

- (void)setBindView:(UIView *)bindView {
    _bindView = bindView;
    CGRect frame = _bindView.frame;
    _bindFrame = (AKTFrameInfo){
        frame.origin.x, frame.origin.y, frame.size.width, frame.size.height
    };
}

#pragma mark - add layout methods
/*
 * Create and add layout attribute item
 */
- (AKTLayoutAttributeItem *)top {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_Top];
}

- (AKTLayoutAttributeItem *)left {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_Left];
}

- (AKTLayoutAttributeItem *)bottom {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_Bottom];
}

- (AKTLayoutAttributeItem *)right {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_Right];
}

- (AKTLayoutAttributeItem *)width {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_Width];
}

- (AKTLayoutAttributeItem *)height {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_Height];
}

- (AKTLayoutAttributeItem *)whRatio {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_WHRatio];
}

- (AKTLayoutAttributeItem *)centerX {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_CenterX];
}

- (AKTLayoutAttributeItem *)centerY {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_CenterY];
}

- (AKTLayoutAttributeItem *)centerXY {
    return [self attributeItemWithType:AKTLayoutAttributeItemType_CenterXY];
}

- (AKTLayoutAttributeItem *)edge {
    // Check whether out of range
    if (self.infoRef->itemCount==kAKTLayoutAttributeItemCapacity) {
        NSLog(@"Out of the range of attributeItemInfo array");
        return nil;
    }
    AKTLayoutAttributeItemInfo itemInfo = [AKTLayoutAttributeItem initializedInfo];
    
    // Add itemInfo to itemInfo array
    self.infoRef->attributeItems[self.infoRef->itemCount] = itemInfo;
    self.infoRef->itemCount++;
    
    // Create a new attributeItem
    AKTLayoutAttributeItemInfoRef itemInfoRef = &(self.infoRef->attributeItems[self .infoRef->itemCount-1]);
    AKTLayoutAttributeItem *item = [AKTLayoutAttributeItem sharedInstanceWithInfoRef:itemInfoRef];
    return item;
}

/*
 * Return attributeItem according to the itemType
 */
- (AKTLayoutAttributeItem *)attributeItemWithType:(AKTLayoutAttributeItemType)type {
    // Check whether out of range
    if (self.infoRef->itemCount==kAKTLayoutAttributeItemCapacity) {
        NSLog(@"Out of the range of attributeItemInfo array");
        return nil;
    }
    AKTLayoutAttributeItemInfo itemInfo = [AKTLayoutAttributeItem initializedInfo];
    // Add itemType to itemInfo
    itemInfo.layoutTypeArray[itemInfo.itemTypeCount] = type;
    itemInfo.itemTypeCount++;
    
    // Add itemInfo to itemInfo array
    self.infoRef->attributeItems[self.infoRef->itemCount] = itemInfo;
    self.infoRef->itemCount++;
    
    // Create a new attributeItem
    AKTLayoutAttributeItemInfoRef itemInfoRef = &(self.infoRef->attributeItems[self .infoRef->itemCount-1]);
    AKTLayoutAttributeItem *item = [AKTLayoutAttributeItem sharedInstanceWithInfoRef:itemInfoRef];
    return item;
}

#pragma mark - universal methods
/*
 * Calculate layout with the infor from the attribute items, return CGRect
 * Configurations in AKTLayoutParam, as follows configurations can be divided into vertical and horizontal direction
 * In one direction two configurations in addition to "whRatio" is enough to calculate the frame in that direction. WhRation will be convert to the configuration of width or height
 * ________________________________________
 * |    verticcal    |     horizontal     |
 * |       top       |        left        |
 * |      bottom     |        right       |
 * |      height     |        width       |
 * |     centerY     |       centerX      |
 * |    >whRatio<    |      >whRatio<     |
 * |_________________|____________________|
 */
- (CGRect)calculateAttribute {
    // Filter out invalid layout items
    if (self.infoRef->itemCount == 0) {
        NSLog(@"Did not add any attribute items");
        UIView *v = self.bindView;
        return CGRectMake(v.x, v.y, v.width, v.height);
    }
    int valideItemCount = 0;
    for (int i = 0; i<self.infoRef->itemCount; i++) {
        AKTLayoutAttributeItemInfo item = self.infoRef->attributeItems[i];
        if (item.referenceObj.referenceValidate == false) {
            continue;
        }else{
            self.infoRef->attributeItems[valideItemCount] = item;
            valideItemCount++;
        }
    }
    self.infoRef->itemCount = valideItemCount;
    
    // If defined edgeInset set frame and return
    {
        // Find which item set the edgeInset
        UIEdgeInsets edgeInset;
        UIView *referenceView;
        AKTLayoutAttributeItemInfo info;
        for (int i = 0; i<self.infoRef->itemCount; i++) {
            info = self.infoRef->attributeItems[i];
            edgeInset = info.referenceObj.referenceInsert;
            referenceView = (__bridge UIView *)(info.referenceObj.referenceView);
        }
        
        // Calculate frame
        if (referenceView && edgeInset.top<kAKTFloatMax) {
            CGFloat x_i, y_i,w_i,h_i;
            CGRect viewRec = [self.bindView.superview convertRect:referenceView.frame fromView:referenceView.superview];
            x_i = viewRec.origin.x+calculate(edgeInset.left, info.referenceObj.referenceMultiple, info.referenceObj.referenceOffset);
            y_i = viewRec.origin.y+calculate(edgeInset.top, info.referenceObj.referenceMultiple, info.referenceObj.referenceOffset);
            w_i = -calculate(edgeInset.left, info.referenceObj.referenceMultiple, info.referenceObj.referenceOffset)+viewRec.size.width-calculate(edgeInset.right, info.referenceObj.referenceMultiple, info.referenceObj.referenceOffset);
            h_i = -calculate(edgeInset.top, info.referenceObj.referenceMultiple, info.referenceObj.referenceOffset)+viewRec.size.height-calculate(edgeInset.bottom, info.referenceObj.referenceMultiple, info.referenceObj.referenceOffset);
            return CGRectMake(x_i, y_i, w_i, h_i);
        }
    }
    
    // No define edgeInset but configured other itemtypes: top/left/width.... Serialize those information and store the result into AKTLayoutParamInfo.
    AKTLayoutParamInfo paramInfo = initializedParamInfo();
    // Get whRatio if exist
    for (int i = 0; i<self.infoRef->itemCount; i++) {
        AKTLayoutAttributeItemInfo itemInfo = self.infoRef->attributeItems[i];
        for (int j = 0; j<itemInfo.itemTypeCount; j++) {
            int num = itemInfo.layoutTypeArray[j];
            if (num == AKTLayoutAttributeItemType_WHRatio) {
                if (itemInfo.referenceObj.referenceType == AKTRefenceType_Constant) {
                    paramInfo.whRatio = itemInfo.referenceObj.referenceConstant;
                }else{
                    UIView *v = (__bridge UIView *)(itemInfo.referenceObj.referenceView);
                    paramInfo.whRatio = calculate(v.width/v.height, itemInfo.referenceObj.referenceMultiple, itemInfo.referenceObj.referenceOffset);
                }
            }
        }
    }
    // Set other itemtypes: top/left/width.... into paramInfo
    for (int i = 0; i<self.infoRef->itemCount; i++) {
        AKTLayoutAttributeItemInfo itemInfo = self.infoRef->attributeItems[i];
        [self parseItemInfoRef:&itemInfo toParamInfoRef:&paramInfo];
    }
    
    return [self calculateRectWithLayoutParamInfoRef:&paramInfo];
}

#pragma mark - aid for frame calculation
/*
 * Parse layout item to layout param
 */
- (void)parseItemInfoRef:(AKTLayoutAttributeItemInfoRef)itemInfoRef toParamInfoRef:(AKTLayoutParamInfoRef)paramInfoRef {
    // All of the layout types in the array
    for (int i = 0; i<itemInfoRef->itemTypeCount; i++) {
        int num = itemInfoRef->layoutTypeArray[i];
        if (itemInfoRef->referenceObj.referenceType == AKTRefenceType_Constant) {
            float result = calculate(itemInfoRef->referenceObj.referenceConstant, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
            switch (num) {
                case AKTLayoutAttributeItemType_Top:
                {
                    paramInfoRef->top = result;
                    break;
                }
                case AKTLayoutAttributeItemType_Left:
                {
                    paramInfoRef->left = result;
                    break;
                }
                case AKTLayoutAttributeItemType_Bottom:
                {
                    paramInfoRef->bottom = result;
                    break;
                }
                case AKTLayoutAttributeItemType_Right:
                {
                    paramInfoRef->right = result;
                    break;
                }
                case AKTLayoutAttributeItemType_Width:
                {
                    paramInfoRef->width = result;
                    break;
                }
                case AKTLayoutAttributeItemType_Height:
                {
                    paramInfoRef->height = result;
                    break;
                }
                case AKTLayoutAttributeItemType_CenterX:
                {
                    paramInfoRef->centerX = result;
                    break;
                }
                case AKTLayoutAttributeItemType_CenterY:
                {
                    paramInfoRef->centerY = result;
                    break;
                }
                case AKTLayoutAttributeItemType_CenterXY:
                {
                    paramInfoRef->centerY = paramInfoRef->centerX = result;
                    break;
                }
                default:
                    break;
            }
        }else{
            UIView *v = (__bridge UIView *)(itemInfoRef->referenceObj.referenceView);
            CGRect viewRec = [self.bindView.superview convertRect:v.frame fromView:v.superview];
            switch (num) {
                case AKTLayoutAttributeItemType_Top:
                {
                    paramInfoRef->top = calculate(viewRec.origin.y, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_Left:
                {
                    paramInfoRef->left = calculate(viewRec.origin.x, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_Bottom:
                {
                    paramInfoRef->bottom = calculate(viewRec.origin.y+viewRec.size.height, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_Right:
                {
                    paramInfoRef->right = calculate(viewRec.origin.x+viewRec.size.width, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_Width:
                {
                    paramInfoRef->width = calculate(viewRec.size.width, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);

                    break;
                }
                case AKTLayoutAttributeItemType_Height:
                {
                    paramInfoRef->height = calculate(viewRec.size.height, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_CenterX:
                {
                    paramInfoRef->centerX = calculate(viewRec.origin.x+viewRec.size.width/2, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_CenterY:
                {
                    paramInfoRef->centerY = calculate(viewRec.origin.y+viewRec.size.height/2, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                case AKTLayoutAttributeItemType_CenterXY:
                {
                    paramInfoRef->centerX = calculate(viewRec.origin.x+viewRec.size.width/2, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    paramInfoRef->centerY = calculate(viewRec.origin.y+viewRec.size.height/2, itemInfoRef->referenceObj.referenceMultiple, itemInfoRef->referenceObj.referenceOffset);
                    break;
                }
                default:
                    break;
            }
        }
    }
}

/*
 * Rect generated by infor in param
 */
- (CGRect)calculateRectWithLayoutParamInfoRef:(AKTLayoutParamInfoRef)paramInfoRef {
    CGRect rect;
    
    // The following are calculation methods
    // whether whRatio is available
    if (paramInfoRef->whRatio<kAKTFloatMax) {
        rect = [self rectWhRatioWithParamInfoRef:paramInfoRef];
    }else{
        rect = [self rectNoWhRatioWithParamInfoRef:paramInfoRef];
    }
    return rect;
}

/*
 * According to param, calculate the size of frame in horizontal direction. When you call the method, please ensure there were no redundant configurations in param.
 * In one direction two configurations in addition to "whRatio" is enough to calculate the frame in that direction. WhRation will be convert to the configuration of width or height
 * @oRect : The frame of the view which will be layout according to the reference view was got before layout
 */
- (CGRect)horizontalCalculationWithParamInfoRef:(AKTLayoutParamInfoRef)paramInfoRef origineRect:(CGRect)oRect {
    CGFloat x, y, width, height;
    x = oRect.origin.x;
    y = oRect.origin.y;
    width = oRect.size.width;
    height = oRect.size.height;
    if (paramInfoRef->centerX<kAKTFloatMax) {
        if (paramInfoRef->left<kAKTFloatMax) {
            x = paramInfoRef->left;
            width = (paramInfoRef->centerX)*2;
        }else if (paramInfoRef->right<kAKTFloatMax) {
            x = paramInfoRef->centerX-(paramInfoRef->right-paramInfoRef->centerX);
            width = (paramInfoRef->right-paramInfoRef->centerX)*2;
        }else if (paramInfoRef->width<kAKTFloatMax) {
            x = paramInfoRef->centerX-paramInfoRef->width/2;
            width = paramInfoRef->width;
        }else if (paramInfoRef->centerX<kAKTFloatMax) {
            x = paramInfoRef->centerX-width/2;
        }
    }else{
        if (paramInfoRef->left<kAKTFloatMax) {
            x = paramInfoRef->left;
            if (paramInfoRef->width<kAKTFloatMax) {
                width = paramInfoRef->width;
            }
            if (paramInfoRef->right<kAKTFloatMax) {
                width = paramInfoRef->right - x;
            }
        }else{
            if (paramInfoRef->width<kAKTFloatMax) {
                width = paramInfoRef->width;
            }
            if (paramInfoRef->right<kAKTFloatMax) {
                x = paramInfoRef->right-width;
            }
        }
    }
    return  CGRectMake(x, y, width, height);
}

/*
 * According to param, calculate the size of frame in vertical direction. When you call the method, please ensure there were no redundant configurations in param.
 * In one direction two configurations in addition to "whRatio" is enough to calculate the frame in that direction. WhRation will be convert to the configuration of width or height
 * @oRect : The frame of the view which will be layout according to the reference view was got before layout
 */
- (CGRect)verticalCalculationWithParamInfoRef:(AKTLayoutParamInfoRef)paramInfRef origineRect:(CGRect)oRect {
    CGFloat x, y, width, height;
    x = oRect.origin.x;
    y = oRect.origin.y;
    width = oRect.size.width;
    height = oRect.size.height;
    if (paramInfRef->centerY<kAKTFloatMax) {
        if (paramInfRef->top<kAKTFloatMax) {
            y = paramInfRef->top;
            height = (paramInfRef->centerY-y)*2;
        }else if (paramInfRef->bottom<kAKTFloatMax) {
            y = paramInfRef->centerY-(paramInfRef->bottom-paramInfRef->centerY);
            height = (paramInfRef->bottom-paramInfRef->centerY)*2;
        }else if (paramInfRef->height<kAKTFloatMax) {
            y = paramInfRef->centerY-paramInfRef->height/2;
            height = paramInfRef->height;
        }else if (paramInfRef->centerY<kAKTFloatMax) {
            y = paramInfRef->centerY-height/2;
        }
    }else{
        if (paramInfRef->top<kAKTFloatMax) {
            y = paramInfRef->top;
            if (paramInfRef->height<kAKTFloatMax) {
                height = paramInfRef->height;
            }
            if (paramInfRef->bottom<kAKTFloatMax) {
                height = paramInfRef->bottom - y;
            }
        }else{
            if (paramInfRef->height<kAKTFloatMax) {
                height = paramInfRef->height;
            }
            if (paramInfRef->bottom<kAKTFloatMax) {
                y = paramInfRef->bottom-height;
            }
        }
    }
    return  CGRectMake(x, y, width, height);
}

/*
 * The param has no configuration for whRatio, return the rect
 */
- (CGRect)rectNoWhRatioWithParamInfoRef:(AKTLayoutParamInfoRef)paramInfoRef {
    AKTFrameInfo frame = self.bindFrame;
    CGRect rect = CGRectMake(frame.x, frame.y, frame.width, frame.height);
    
    // Block for checking and removing redundant configurations in horizontal direction
    int (^CheckConfigurationInNoRatio_Horizontal)() = ^int(){
        int hCount = 0;
        if (paramInfoRef->left<kAKTFloatMax) {
            hCount++;
        }
        if (paramInfoRef->right<kAKTFloatMax) {
            hCount++;
            if (hCount>2) {
                paramInfoRef->right = FLT_MAX;
                hCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: right", self.name);
            }
        }
        if (paramInfoRef->width<kAKTFloatMax) {
            hCount++;
            if (hCount>2) {
                paramInfoRef->width = FLT_MAX;
                hCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: width", self.name);
            }
        }
        if (paramInfoRef->centerX<kAKTFloatMax) {
            hCount++;
            if (hCount>2) {
                paramInfoRef->centerX = FLT_MAX;
                hCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: width", self.name);
            }
        }
        return hCount;
    };
    
    // Block for checking and removing redundant configurations in vertical direction
    int (^CheckConfigurationInNoRatio_Vertical)() = ^int(){
        int vCount = 0;
        if (paramInfoRef->top<kAKTFloatMax) {
            vCount++;
        }
        if (paramInfoRef->bottom<kAKTFloatMax) {
            vCount++;
            if (vCount>2) {
                paramInfoRef->bottom = FLT_MAX;
                vCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: bottom", self.name);
            }
        }
        if (paramInfoRef->height<kAKTFloatMax) {
            vCount++;
            if (vCount>2) {
                paramInfoRef->height = FLT_MAX;
                vCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: height", self.name);
            }
        }
        if (paramInfoRef->centerY<kAKTFloatMax) {
            vCount++;
            if (vCount>2) {
                paramInfoRef->centerY = FLT_MAX;
                vCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: height", self.name);
            }
        }
        return vCount;
    };
    
    // Calculate the size of the frame in the horizontal & vertical direction, specially centerX & centerY get priority to meet
    // Check redundant configuration, if found report it
    // Redundant configurations will be abandoned after perform the following operations, otherwise a lack of configurations
    int horizonCount = CheckConfigurationInNoRatio_Horizontal();
    // Set view's height adaptive
    if (horizonCount == 2) {
        self.bindView.adaptiveWidth = NO;
    }
    rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
    int verticalCount = CheckConfigurationInNoRatio_Vertical();
    // Set view's width adaptive
    if (verticalCount == 2) {
        self.bindView.adaptiveHeight = NO;
    }
    rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
    return rect;
}

/*
 * The param has the configuration for whRatio, return the rect
 */
- (CGRect)rectWhRatioWithParamInfoRef:(AKTLayoutParamInfoRef)paramInfoRef {
    __block CGRect rect = CGRectMake(self.bindFrame.x, self.bindFrame.y, self.bindFrame.width, self.bindFrame.height);
    
    // Block for checking and removing redundant configurations in horizontal direction
    int (^CheckConfigurationInRatio_Horizontal)() = ^int(){
        int hCount = 0;
        if (paramInfoRef->left<kAKTFloatMax) {
            hCount++;
        }
        if (paramInfoRef->right<kAKTFloatMax) {
            hCount++;
            if (hCount>2) {
                paramInfoRef->right = FLT_MAX;
                hCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: right", self.name);
            }
        }
        if (paramInfoRef->width<kAKTFloatMax) {
            hCount++;
            if (hCount>2) {
                paramInfoRef->width = FLT_MAX;
                hCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: width", self.name);
            }
        }
        if (paramInfoRef->centerX<kAKTFloatMax) {
            hCount++;
            if (hCount>2) {
                paramInfoRef->centerX = FLT_MAX;
                hCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: centerX", self.name);
            }
        }
        return hCount;
    };
    
    // Block for checking and removing redundant configurations in vertical direction
    int (^CheckConfigurationInRatio_Vertical)() = ^int(){
        int vCount = 0;
        if (paramInfoRef->top<kAKTFloatMax) {
            vCount++;
        }
        if (paramInfoRef->bottom<kAKTFloatMax) {
            vCount++;
            if (vCount>2) {
                paramInfoRef->bottom = FLT_MAX;
                vCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: bottom", self.name);
            }
        }
        if (paramInfoRef->height<kAKTFloatMax) {
            vCount++;
            if (vCount>2) {
                paramInfoRef->height = FLT_MAX;
                vCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: height", self.name);
            }
        }
        if (paramInfoRef->centerY<FLT_MAX) {
            vCount++;
            if (vCount>2) {
                paramInfoRef->centerY = FLT_MAX;
                vCount--;
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: centerY", self.name);
            }
        }
        return vCount;
    };
    
    // The result of vertical and horizontal checking, count == 2 means that the configurations were enough,
    // count < 2 means less configuration
    int hCount = 0, vCount = 0;
    hCount = CheckConfigurationInRatio_Horizontal();
    vCount = CheckConfigurationInRatio_Vertical();
    
    void (^CalculateSum0)() = ^() {
        paramInfoRef->height = rect.size.width/paramInfoRef->whRatio;
        rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
    };
    
    void (^CalculateSum1)() = ^() {
        if (hCount == 1) {
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            paramInfoRef->height = rect.size.width/paramInfoRef->whRatio;
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }else{
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            paramInfoRef->width = rect.size.height*paramInfoRef->whRatio;
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }
    };
    
    void (^CalculateSum2)() = ^() {
        if (hCount == 0) {
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            // vCount = 2, hCount = 0 and whRatio is existing means that the view's width and height can't be adaptive.
            self.bindView.adaptiveWidth = self.bindView.adaptiveHeight = NO;
            paramInfoRef->width = rect.size.height*paramInfoRef->whRatio;
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }else if (hCount == 1) {
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            if (paramInfoRef->height<kAKTFloatMax) {
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: whRatio", self.name);
            }else{
                paramInfoRef->height = rect.size.width/paramInfoRef->whRatio;
            }
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }else if (hCount == 2) {
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            // vCount = 0, hCount = 2 and whRatio is existing means that the view's width and height can't be adaptive.
            self.bindView.adaptiveWidth = self.bindView.adaptiveHeight = NO;
            paramInfoRef->height = rect.size.width/paramInfoRef->whRatio;
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }
    };
    
    void (^CalculateSum3)() = ^() {
        // vCount + hCount = 3 and whRatio is existing means that the view's width and height can't be adaptive.
        self.bindView.adaptiveWidth = self.bindView.adaptiveHeight = NO;
        if (hCount == 1) {
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            if (paramInfoRef->width<kAKTFloatMax) {
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: whRatio", self.name);
            }else{
                paramInfoRef->width = rect.size.height*paramInfoRef->whRatio;
            }
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }else if (hCount == 2) {
            rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
            if (paramInfoRef->height<kAKTFloatMax) {
                NSLog(@"AKTLayoutReporter:%@ has redundant configuration: whRatio", self.name);
            }else{
                paramInfoRef->height = rect.size.width/paramInfoRef->whRatio;
            }
            rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        }
    };
    
    void (^CalculateSum4)() = ^() {
        // vCount + hCount = 4 and whRatio is existing means that the view's width and height can't be adaptive.
        self.bindView.adaptiveWidth = self.bindView.adaptiveHeight = NO;
        rect = [self horizontalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        rect = [self verticalCalculationWithParamInfoRef:paramInfoRef origineRect:rect];
        int currentRatio = (int)(1000*rect.size.width/rect.size.height);
        int whRatio = paramInfoRef->whRatio*1000;
        if (currentRatio != whRatio) {
            NSLog(@"AKTLayoutReporter:%@ has redundant configuration: whRatio", self.name);
        }
    };
    
    switch (hCount+vCount) {
        case 0:// vertical & horizontal had no configuration
        {
            CalculateSum0();
            break;
        }
        case 1:// vertical or horizontal had one configuration
        {
            CalculateSum1();
            break;
        }
        case 2:// vertical & horizontal will be 1+1 or 0+2 or 2+0
        {
            CalculateSum2();
            break;
        }
        case 3:// vertical & horizontal will be 1+2 or 2+1
        {
            CalculateSum3();
            break;
        }
        case 4:// vertical & horizontal will be 2+2
        {
            CalculateSum4();
            break;
        }
        default:
            break;
    }
    return rect;
}








/*
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 *-------|The following are function implementations that is provided to the external call|
 *       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 */
#pragma mark - function implementations
//|---------------------------------------------------------------------------------------------------------------------------
/*
 * Return an initializedParamInfo
 */
AKTLayoutParamInfo initializedParamInfo() {
    return (AKTLayoutParamInfo){
        .top = FLT_MAX,
        .left = FLT_MAX,
        .bottom = FLT_MAX,
        .right = FLT_MAX,
        .width = FLT_MAX,
        .height = FLT_MAX,
        .whRatio = FLT_MAX,
        .centerX = FLT_MAX,
        .centerY = FLT_MAX
    };
}
@end

