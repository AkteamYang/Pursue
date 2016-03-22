//
//  NSString+AKTFilePath.h
//  Export
//
//  Created by YaHaoo on 16/1/21.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import <Foundation/Foundation.h>

//--------------------Structs statement & globle variables...--------------------
/*
 * Relative path type enumeration
 */
typedef NS_ENUM(NSInteger, AKTFilePathRelativePathType) {
    AKTFilePathRelativePathType_MainBundle,
    AKTFilePathRelativePathType_Home,
    AKTFilePathRelativePathType_Documents,
    AKTFilePathRelativePathType_Library,
    AKTFilePathRelativePathType_Tmp,
    AKTFilePathRelativePathType_Library_Caches,
    AKTFilePathRelativePathType_Library_Preferences
};
//-------------------- E.n.d -------------------->Structs statement & globle variables...

@interface NSString (AKTFilePath)
/*
 * Return corresponding absolute path according to the path type
 */
+ (NSString *)aktFilePathWithType:(AKTFilePathRelativePathType)relativePathType;

/*
 * Add path with path component
 */
- (NSString *(^)(NSString *))addPath;

/*
 * Appent string
 * objStr could be NSString or NSNumber
 */
- (NSString *(^)(NSObject *objStr))add;
@end


