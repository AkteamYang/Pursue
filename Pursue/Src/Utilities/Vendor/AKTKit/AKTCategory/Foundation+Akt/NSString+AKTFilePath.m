//
//  NSString+AKTFilePath.m
//  Export
//
//  Created by YaHaoo on 16/1/21.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "NSString+AKTFilePath.h"

@implementation NSString (AKTFilePath)
/*
 * Return corresponding absolute path according to path type
 */
+ (NSString *)aktFilePathWithType:(AKTFilePathRelativePathType)relativePathType
{
    NSString *path;
    switch (relativePathType) {
        case AKTFilePathRelativePathType_Documents:
            path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject;
            break;
        case AKTFilePathRelativePathType_Home:
            path = NSHomeDirectory();
            break;
        case AKTFilePathRelativePathType_Library:
            path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES).firstObject;
            break;
        case AKTFilePathRelativePathType_Library_Caches:
            path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES).firstObject;
            break;
        case AKTFilePathRelativePathType_Library_Preferences:
            path = [NSString aktFilePathWithType:AKTFilePathRelativePathType_Library].addPath(@"Preferences");
            break;
        case AKTFilePathRelativePathType_MainBundle:
            path = [[NSBundle mainBundle] bundlePath];
            break;
        case AKTFilePathRelativePathType_Tmp:
            path = NSTemporaryDirectory();
            break;
        default:
            break;
    }
    return path;
}

/*
 * Add path with path component
 */
- (NSString *(^)(NSString *))addPath
{
    return ^NSString *(NSString *addPath) {
        return [self stringByAppendingString:[NSString stringWithFormat:@"/%@",addPath]];
    };
}

/*
 * Appent string
 */
- (NSString *(^)(NSObject *objStr))add
{
    return ^NSString *(NSObject *objStr) {
        return [self stringByAppendingString:[NSString stringWithFormat:@"%@",objStr.description]];
    };
}
@end
