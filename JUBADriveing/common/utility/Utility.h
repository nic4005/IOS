//
//  Utility.h
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kPathFlagRetina = @"@2x";
static NSString *const kPathFlagBig = @"_big";
static NSString *const kPathFlagHighlighted = @"Hlt";

@interface Utility : NSObject
+ (NSString *)pathOfResourceFile:(NSString *)path;
+ (NSString *)pathByAppedingFlag:(NSString *)flag toFilePath:(NSString *)path;

// GCD
+ (void)performeBackgroundTask:(void (^)(void))backgroundBlock beforeMainTask:(void(^)(void))mainBlock;

// string
+ (NSString *)join:(NSArray *)array withSeparator:(NSString *)separator;

// frame
+ (CGPoint)centerOfFrame:(CGRect)frame;
+ (CGPoint)absoluteCenterOfFrame:(CGRect)frame;
+ (CGRect)frame:(CGRect)rect onView:(UIView *)view bottomCornerOffset:(CGPoint)offset;
+ (CGSize)sizeByResize:(CGSize)size withFactor:(CGFloat)factor;
+ (CGRect)centralRectFromFrame:(CGRect)frame;
+ (CGRect)adjustedFrame:(CGRect)frame againstCenter:(CGPoint)center;
+ (CGRect)centralFrame:(CGRect)front onFrame:(CGRect)back;

//angle
+ (CGFloat)arcRadiansAngleOfStartPoint:(CGPoint)start endPoint:(CGPoint)end;
+ (CGFloat)distanceOfStartPoint:(CGPoint)start endPoint:(CGPoint)end;
+ (CGPoint)centerOfStartPoint:(CGPoint)start endPoint:(CGPoint)end;


// view
+ (void)presentViewOnMainScreen:(UIView *)view animated:(BOOL)animated;
+ (void)presentAlertView:(NSString *)title message:(NSString *)msg;
+ (CGRect)mainWindowBounds;
+ (UIWindow *)mainWindow;

+ (void)lockUserInteraction;
+ (void)unlockUserInteraction;
+ (void)lockUserInteractionWithDuration:(NSTimeInterval)time;


// image
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+ (UIView *)strokeWithSize:(CGSize)size andColor:(UIColor *)color;

+ (UIView *) viewFromRoundAndStrokImage:(UIImage *)imageView;

+ (void)addMotionEffect:(UIImageView *)imageView horMin:(CGFloat)horMin horMax:(CGFloat)horMax verMin:(CGFloat)verMin verMax:(CGFloat)verMax;

// date
+ (NSDate *)randomDateOfTheYear;
+ (NSString *)currentDate;
+ (NSString *)dateWithAfterTodayDays:(NSInteger)days;

// animation
+ (void)pulsateOnceForView:(UIView *)view;


// activity
+ (void)presentHud:(NSString *)greeting;
+ (void)dismissHud;


// system

//local
+ (void)saveDataForUserDefault:(NSString *)key data:(id)data;
+ (void)removeDataFromUserDefault:(NSString *)key;
+ (id)gainLocalDataFromUserDefault:(NSString *)key;
+ (BOOL)isFirstStartApplication;
// device
+ (BOOL)isRetina;
+ (UIInterfaceOrientation) screenOrientation;

// story board
+ (id)controllerFromMainStoryboardWithIdentifier:(NSString *)identifier;


//url
+ (NSString *)requestURL:(NSString *)api parameters:(NSString *)parmeters;

//sound
+(void)playClickSound;

//#pragma mark
#pragma mark-  validate data
+ (BOOL)validateEmail:(NSString *)email;

+ (BOOL) validatePassword:(NSString *)password;

@end
