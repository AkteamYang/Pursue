//
//  Public.h
//  AKTeamUikitExtension
//
//  Created by YaHaoo on 15/9/6.
//  Copyright (c) 2015年 CoolHear. All rights reserved.
//

#ifndef AKTeamUikitExtension_Public_h
#define AKTeamUikitExtension_Public_h
//--------------# System related #--------------
#import "AppDelegate.h"
#define mAKT_SCREENWITTH ([UIScreen mainScreen].bounds.size.width)
#define mAKT_SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define mAKT_APPDELEGATE ((AppDelegate *) ([UIApplication sharedApplication].delegate))

// Version
#define mAKT_SystemVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// Language
#define mAKT_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

// Simulator or Device
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif
//--------------# E.n.d #--------------#>System related

//--------------# UI related #--------------
#import <UIKit/UIKit.h>

// UIimage
#define mAKT_Image(N) [UIImage imageNamed:N]

// Font
#define mAKT_FontRegular(S) [UIFont systemFontOfSize:S]
#define mAKT_FontBold(S) [UIFont boldSystemFontOfSize:S]
#define mAKT_Font_S [UIFont systemFontOfSize:20]
#define mAKT_Font_SS [UIFont systemFontOfSize:18]
#define mAKT_Font_SSS [UIFont systemFontOfSize:16]
#define mAKT_Font_SSSS [UIFont systemFontOfSize:14]
#define mAKT_Font_SSSSS [UIFont systemFontOfSize:12]
#define mAKT_Font_Bold_S [UIFont boldSystemFontOfSize:20]
#define mAKT_Font_Bold_SS [UIFont boldSystemFontOfSize:18]
#define mAKT_Font_Bold_SSS [UIFont boldSystemFontOfSize:16]
#define mAKT_Font_Bold_SSSS [UIFont boldSystemFontOfSize:14]
#define mAKT_Font_Bold_SSSSSS [UIFont boldSystemFontOfSize:12]

// Color setting
#define mAKT_COLOR_Color(R,G,B,α) ([[UIColor alloc]initWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:α])
#define mAKT_Color_White ([UIColor whiteColor])
#define mAKT_Color_Black ([UIColor blackColor])
#define mAKT_Color_DarkGray ([UIColor darkGrayColor])
#define mAKT_Color_LightGray ([UIColor lightGrayColor])
#define mAKT_Color_Red ([UIColor redColor])
#define mAKT_Color_Green ([UIColor greenColor])
#define mAKT_Color_Blue ([UIColor blueColor])
#define mAKT_Color_Cyan ([UIColor cyanColor])
#define mAKT_Color_Yellow ([UIColor yellowColor])
#define mAKT_Color_Magenta ([UIColor magentaColor])
#define mAKT_Color_Orange ([UIColor orangeColor])
#define mAKT_Color_Purple ([UIColor purpleColor])
#define mAKT_Color_Brown ([UIColor brownColor])
#define mAKT_Color_Clear ([UIColor clearColor])
// Random color
#define mAKT_Color_Random mAKT_COLOR_Color(arc4random()%255,arc4random()%255,arc4random()%255,.2)

#define mAKT_Color_Text_X (mAKT_COLOR_Color(255,255,255,1))
#define mAKT_Color_Text_XX (mAKT_COLOR_Color(154,154,154,1))
#define mAKT_Color_Text_XXX (mAKT_COLOR_Color(102,102,102,1))
#define mAKT_Color_Text_XXXX (mAKT_COLOR_Color(52,52,52,1))

#define mAKT_Color_Background_X (mAKT_COLOR_Color(238,238,238,1))
#define mAKT_Color_Background_XX (mAKT_COLOR_Color(230,230,230,1))
#define mAKT_Color_Background_XXX (mAKT_COLOR_Color(204,204,204,1))

// Add select effect
#define mAKt_BUTTON_MASK(VIEW)     UIView *mask = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];\
mask.backgroundColor = [UIColor blackColor];\
mask.alpha = .4;\
[(VIEW) addSubview:mask];\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
[mask removeFromSuperview];\
})
//--------------# E.n.d #--------------#>UI related

//--------------# Foundation related #--------------
// NSUserDefault
#define mAKT_UDGetObj(KEY) [[NSUserDefaults standardUserDefaults] objectForKey:(KEY)]
#define mAKT_UDSetObj(OBJ,KEY)  [[NSUserDefaults standardUserDefaults] setObject:(OBJ) forKey:(KEY)]; [[NSUserDefaults standardUserDefaults] synchronize]

// AKTLog
#ifdef DEBUG
#define mAKT_Log(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define mAKT_Log(fmt, ...)
#endif

// Internationalization
#define mAKT_LocalStr(x) NSLocalizedString(x, nil)
//--------------# E.n.d #--------------#>Foundation related

//--------------# Mathematics related #--------------
// Radian & Degree convert
#define mAKT_DegToRad(x) (M_PI * (x) / 180.0)
#define mAKT_RadToDeg(radian) (radian*180.0)/(M_PI)

// Safty check whether "a" is equal to "b". Support: int float or double
bool aktValueEqual(double a, double b);
#define mAKT_EQ(A, B) __AKT_EQ_IMPL__(A, B)
#define __AKT_EQ_IMPL__(A, B) (aktValueEqual(A, B))
//--------------# E.n.d #--------------#>Mathematics related
#endif
