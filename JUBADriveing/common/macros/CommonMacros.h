//
//  CommonMacros.h
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#ifndef ciwenKids_CommonMacros_h
#define ciwenKids_CommonMacros_h

//==================string==================
#define STRING_FROM_NUMBER(number) [NSString stringWithFormat:@"%i", (int)number]
#define FORMATED_STRING(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

//==================selector==================
#define SELE(sel) @selector(sel)
#define REGISTER_NOTIFICATION(se, nName) REGISTER_NOTIFICATION3(se, nName, nil)
#define REGISTER_NOTIFICATION3(se, nName, obj) REGISTER_NOTIFICATION4(self, se, nName, obj)
#define REGISTER_NOTIFICATION4(obs, se, nName, obj) [[NSNotificationCenter defaultCenter] addObserver:obs selector:SELE(se) name:nName object:obj]
#define POST_NOTIFICATION(name) POST_NOTIFICATION2(name, nil)
#define POST_NOTIFICATION2(name, obj) POST_NOTIFICATION3(name, obj, nil)
#define POST_NOTIFICATION3(name, obj, info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]

//==================image==================
#define UIIMAGE_NAMED(name) [UIImage imageNamed:name]
#define UIIMAGE_FORMATED(fmt, ...) [UIImage imageNamed:FORMATED_STRING(fmt, ##__VA_ARGS__)]
#define UIIMAGEVIEW_NAMED(name) [[UIImageView alloc] initWithImage:UIIMAGE_NAMED(name)]
#define UIIMAGEVIEW_FORMATED(fmt,...) [[UIImageView alloc] initWithImage:UIIMAGE_FORMATED(fmt, ##__VA_ARGS__)]
#define UIIMAGE_OF_FILE(path) [UIImage imageWithContentsOfFile:path]
#define UIIMAGEVIEW_OF_FILE(path) [[UIImageView alloc] initWithImage:UIIMAGE_OF_FILE(path)]

//==================device==================
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CURRENT_LANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//iOS Version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//==================method==================
#define IF_RETURN(con) if(con) return

//==================GCD==================
#pragma mark -
#pragma mark block
#define GCD_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define WEEK_REF(obj) __weak typeof(obj) __##obj = obj
#define BLOCK_REF(obj) __block typeof(obj) __##obj = obj



//==================math==================
#define DEGREES_TO_RADIAN(degrees) (M_PI * (degrees) / 180.0)
#define RADIAN_TO_DEGREES(radian) ((radian) * 180.0 / M_PI)
#define SCREEN_SCALE_FACTOR [[UIScreen mainScreen] scale]

#pragma mark -
#pragma mark color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//rgbValue is a Hex vaule without prefix 0x
#define UIColorFromRGB(rgbValue) RGBCOLOR((float)((0x##rgbValue & 0xFF0000) >> 16), (float)((0x##rgbValue & 0xFF00) >> 8), (float)(0x##rgbValue & 0xFF))
#define THEMECOLORD  RGBCOLOR(74,185,162)



//==================log==================
#ifndef __OPTIMIZE__
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif


#ifdef DEBUG //debug
#   define JSON_QUERY_ASSET_VALUE_ENV 1
#   define DLOG(fmt, ...) NSLog((@"%@->%@ <Line %d>: " fmt), NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, ##__VA_ARGS__)

#   define _pts(size) DLOG(@"CGSize: {%.0f, %.0f}", (size).width, (size).height)
#   define _ptr(rect) DLOG(@"CGRect: {{%.1f, %.1f}, {%.1f, %.1f}}", (rect).origin.x, (rect).origin.y, (rect).size.width, (rect).size.height)
#   define _pto(obj) DLOG(@"object %s: %@", #obj, [(obj) description])
#   define _ptm    NSLog(@"\nmark called %s, at line %d", __PRETTY_FUNCTION__, __LINE__)
#   define _if(con, expr) if(con) expr

#   define ULOG(fmt, ...)  { \
NSString *title = [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__]; \
NSString *msg = [NSString stringWithFormat:fmt, ##__VA_ARGS__];     \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title       \
message:msg         \
delegate:nil         \
cancelButtonTitle:@"OK"       \
otherButtonTitles:nil];       \
[alert show]; \
}
#else //release
#   define JSON_QUERY_ASSET_VALUE_ENV 2
#   define DLOG(...)
#   define ULOG(...)
#   define _pts(size)
#   define _ptr(rect)
#   define _pto(obj)
#   define _ptm
#   define _if(con, expr)
#endif

#define SAFE_ASSIGN_ARRAY(con) if(con) return
#endif
