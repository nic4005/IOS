//
//  Utility.m
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#include <sys/sysctl.h>
#import <sys/xattr.h>
#import "ClickSoundManager.h"
#import <Accelerate/Accelerate.h>
#import "DFAppDelegate.h"
#import "CWUserDataManager.h"

@implementation Utility
#pragma mark -
#pragma mark  file path
+ (NSString *)pathOfResourceFile:(NSString *)path {
    return [[self resourceDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathByAppedingFlag:(NSString *)flag toFilePath:(NSString *)path  {
    NSString *extension = [path pathExtension];
    NSString *pathBody = [path stringByDeletingPathExtension];
    NSString *retinaPath = FORMATED_STRING(@"%@%@.%@", pathBody, flag, extension);
    //    NSLog(@"new file path: %@", retinaPath);
    return retinaPath;
}

+ (NSString *)resourceDirectory {
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    
    return resourceDir;
}
#pragma mark -
#pragma mark storyboard
+ (id)controllerFromMainStoryboardWithIdentifier:(NSString *)identifier {

        return [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark -
#pragma mark string
//join string array
+ (NSString *)join:(NSArray *)array withSeparator:(NSString *)separator {
    if (array.count == 1) {
        return array[0];
    } else {
        NSString *str = array[0];
        for (int i=1; i < array.count; i++) {
            NSString *anotherString = array[i];
            str = [str stringByAppendingFormat:@"%@%@", separator, anotherString];
        }
        return str;
    }
}

#pragma mark -
#pragma mark position
+ (CGPoint)centerOfFrame:(CGRect)frame {
    return CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
}

+ (CGRect)adjustedFrame:(CGRect)frame againstCenter:(CGPoint)center { //get round of 0.5 point
    int x = center.x - frame.size.width/2;
    int y = center.y - frame.size.height/2;
    frame.origin = CGPointMake(x, y);
    
    return frame;
}

+ (CGRect)centralFrame:(CGRect)front onFrame:(CGRect)back {
    CGPoint center = [self absoluteCenterOfFrame:back];
    
    return [self adjustedFrame:front againstCenter:center];
}

+ (CGPoint)absoluteCenterOfFrame:(CGRect)frame {
    return CGPointMake(frame.size.width/2, frame.size.height/2);
}

+ (CGRect)frame:(CGRect)rect onView:(UIView *)view bottomCornerOffset:(CGPoint)offset {
    CGPoint origin = CGPointMake(view.frame.size.width-offset.x, view.frame.size.height-offset.y);
    
    rect.origin = origin;
    
    return rect;
}

+ (CGSize)sizeByResize:(CGSize)size withFactor:(CGFloat)factor {
    return CGSizeMake(size.width * factor, size.height * factor);
}

+ (CGRect)centralRectFromFrame:(CGRect)frame {
    int gapX = frame.size.width/4;
    int gapY = frame.size.height/4;
    return CGRectMake(frame.origin.x+gapX, frame.origin.y+gapY, gapX*2, gapY*2);
}

#pragma mark -
#pragma mark angle
+ (CGFloat)arcRadiansAngleOfStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    CGPoint originPoint = CGPointMake(end.x - start.x, start.y - end.y);
    float radians = atan2f(originPoint.y, originPoint.x);
    
    radians = radians < 0.0 ? (M_PI*2 + radians) : radians;
    
    NSLog(@"arc radians is %f", radians);
    
    return M_PI*2 - radians;
}

+ (CGFloat)distanceOfStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    int originX = end.x - start.x;
    int originY = end.y - start.y;
    
    
    return sqrt(originX*originX + originY*originY);
}

+ (CGPoint)centerOfStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    return CGPointMake((end.x + start.x)/2, (end.y + start.y)/2);
}

#pragma mark -
#pragma mark GCD
+ (void)performeBackgroundTask:(void (^)(void))backgroundBlock beforeMainTask:(void (^)(void))mainBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        backgroundBlock();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            mainBlock();
        });
    });
}


#pragma mark -
#pragma mark image
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //image.scale or [UIScreen mainScreen].scale)
	UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale); //create a graphics image context
    //    UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)]; //draw in context
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); //new image
	
	UIGraphicsEndImageContext();
	
	return newImage;
}


+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = (CGRect){0, 0, image.size};
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    [color set];
    
    CGContextFillRect(context, area);
    CGContextRestoreGState(context);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color {
    //decode color
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    CGColorRef colorRef = color.CGColor;
    int numComponents = CGColorGetNumberOfComponents(colorRef);
    const float *colors = CGColorGetComponents(colorRef);
    if (numComponents == 2) {
        red = green = blue = colors[0];
        alpha = colors[1];
    } else if (numComponents == 4) {
        red = colors[0];
        green = colors[1];
        blue = colors[2];
        alpha = colors[3];
    }
    
    //decode image
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(width * height * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPercomponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPercomponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, (CGRect){0, 0, width,height}, imageRef);
    CGContextRelease(context);
    
    // change color
    int byteIndex = 0;
    for (int ii=0; ii < width*height; ii++) {
        rawData[byteIndex] = (char)(red * 255);
        rawData[byteIndex+1] = (char)(green * 255);
        rawData[byteIndex+2] = (char)(blue * 255);
        //        if(rawData[byteIndex+3]>0) rawData[byteIndex+3] = (char)(alpha * 255);
        rawData[byteIndex+3] = (char)(alpha * rawData[byteIndex+3]);
        
        byteIndex += 4;
    }
    
    //create new image
    CGContextRef ctx;
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth(imageRef),
                                CGImageGetHeight(imageRef),
                                bitsPercomponent,
                                CGImageGetBytesPerRow(imageRef),
                                CGImageGetColorSpace(imageRef),
                                kCGBitmapFloatComponents);
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *rawImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    //模糊度,
    //    if ((blur < 0.1f) || (blur > 2.0f)) {
    //        blur = 0.5f;
    //    }
    //boxSize必须大于0
    int boxSize =(int)blur;
    boxSize -= (boxSize % 2) + 1;
    //图像处理
    CGImageRef img = image.CGImage;
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


+ (UIView *)strokeWithSize:(CGSize)size andColor:(UIColor *)color {
    UIView *stroke = [[UIView alloc] initWithFrame:(CGRect){0, 0, size}];
    stroke.backgroundColor = color;
    
    return stroke;
}


+ (UIView *) viewFromRoundAndStrokImage:(UIImage *)image {
    // make new layer to contain shadow and masked image
    CGRect rect = (CGRect){0, 0, image.size};
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 2.5f;
    containerLayer.shadowOffset = CGSizeMake(0.f, 1.f);
    containerLayer.shadowOpacity = 0.8;
    
    // use the image to mask the image into a circle
    CALayer *contentLayer = [CALayer layer];
    contentLayer.contents = (id)image.CGImage;
    contentLayer.frame = rect;
    
    contentLayer.borderColor = [UIColor colorWithRed:0.825 green:0.82 blue:0.815 alpha:1.0].CGColor;
    contentLayer.borderWidth = 1.0;
    contentLayer.cornerRadius = 6.0;
    contentLayer.masksToBounds = YES;
    
    // add masked image layer into container layer so that it's shadowed
    [containerLayer addSublayer:contentLayer];
    
    // add container including masked image and shadow into view
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:contentLayer];
    
    return view;
}

+ (void)roundAndStrokImageView:(UIImageView *)imageView {
}

+ (void)addMotionEffect:(UIImageView *)imageView horMin:(CGFloat)horMin horMax:(CGFloat)horMax verMin:(CGFloat)verMin verMax:(CGFloat)verMax{
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(horMin);
    horizontalMotionEffect.maximumRelativeValue = @(horMax);
    [imageView addMotionEffect:horizontalMotionEffect];
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(verMin);
    verticalMotionEffect.maximumRelativeValue = @(verMax);
    [imageView addMotionEffect:verticalMotionEffect];
}

#pragma mark -
#pragma mark view
+ (void)presentViewOnMainScreen:(UIView *)view animated:(BOOL)animated {
    UIWindow *window = [self mainWindow];
    
    if (animated) {
        view.alpha = 0.0;
        
        [window.rootViewController.view addSubview:view];
        [UIView animateWithDuration:0.3 animations:^{view.alpha = 1.0;}];
    } else {
        [window.rootViewController.view addSubview:view];
    }
}

+ (void)presentAlertView:(NSString *)title message:(NSString *)msg { //just an OK button
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    
    /*try to change the font of the alert label
     for (UIView *view in alertView.subviews) {
     if ([view isKindOfClass:[UILabel class]]) {
     UILabel* label = (UILabel*)view;
     label.font = [UIFont fontWithName:@"Helvetica" size:18]; //STHeitiSC-Medium
     } else if ([view isKindOfClass:[UIButton class]]) {
     UIButton *button = (UIButton *)view;
     button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18]; //
     button.titleLabel.textColor = [UIColor redColor];
     }
     }*/
    
    
    [alertView show];
}


+ (CGRect)mainWindowBounds {
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && rect.size.width<rect.size.height) {
        CGFloat width = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = width;
    }
    
    return rect;
}


+ (UIWindow *)mainWindow {
    UIWindow *mainWindow = [(DFAppDelegate *)[UIApplication sharedApplication].delegate window];
    if (mainWindow == nil) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        
        if(windows.count>0) mainWindow = [windows objectAtIndex:0];
    }
    
    return mainWindow;
}


#pragma mark -
#pragma mark interaction
+ (void)lockUserInteraction {
    UIWindow *window = [self mainWindow];
    
    [window setUserInteractionEnabled:NO];
    
    NSLog(@"time start lock user screen.....");
}

+ (void)unlockUserInteraction {
    UIWindow *window = [self mainWindow];
    
    [window setUserInteractionEnabled:YES];
    
    NSLog(@"time end lock user screen.....");
}

+ (void)lockUserInteractionWithDuration:(NSTimeInterval)time {
    [self lockUserInteraction];
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(unlockUserInteraction)
                                   userInfo:nil
                                    repeats:NO];
}


#pragma mark -
#pragma mark date
+ (NSDate *)randomDateOfTheYear {
    NSDate *today = [NSDate date];
    NSTimeInterval interval = arc4random_uniform(60 * 60 * 24 * 360);
    
    NSDate *date = [today dateByAddingTimeInterval:-interval];
    
    return date;
}

+ (NSString *)currentDate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    /*
     NSDate *now = [NSDate date];
     NSLog(@"now date is: %@", now);
     
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
     
     int year = [dateComponent year];
     int month = [dateComponent month];
     int day = [dateComponent day];
     int hour = [dateComponent hour];
     int minute = [dateComponent minute];
     int second = [dateComponent second];
     
     NSLog(@"year is: %d", year);
     NSLog(@"month is: %d", month);
     NSLog(@"day is: %d", day);
     NSLog(@"hour is: %d", hour);
     NSLog(@"minute is: %d", minute);
     NSLog(@"second is: %d", second);
     */
    return date;
}

+ (NSString *)dateWithAfterTodayDays:(NSInteger)days{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    date = date+60*60*24*days;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd"];
    NSString *dateTime = [formatter stringFromDate:confromTimesp];
    return dateTime;
}

#pragma mark -
#pragma mark animation
+ (void)pulsateOnceForView:(UIView *)view {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleUp.duration = 0.125;
    scaleUp.repeatCount = 1;
    scaleUp.autoreverses = YES;
    scaleUp.removedOnCompletion = YES;
    scaleUp.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [view.layer addAnimation:scaleUp forKey:@"scaleUp"];
}



#pragma mark -
#pragma mark local
+ (void)saveDataForUserDefault:(NSString *)key data:(id)data{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:data];
    [userDefault setObject:udObject forKey:key];
    [userDefault synchronize];
}


+ (void)removeDataFromUserDefault:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

+ (id)gainLocalDataFromUserDefault:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    CWUserDataManager *userData = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefault objectForKey:key]];
    return userData;
}

+ (BOOL)isFirstStartApplication{
    BOOL isFirst = NO;
    NSUserDefaults *userDefault = [NSUserDefaults  standardUserDefaults];
    isFirst = [[userDefault objectForKey:CONST_USER_DATA] isEqualToString:@"FIRST"]?NO:YES;
    if (isFirst) {
        [userDefault setObject:@"FIRST" forKey:CONST_USER_DATA];
        [userDefault synchronize];
    }
    return isFirst;
}
#pragma mark -
#pragma mark activity
+ (MBProgressHUD *)mainWindowHud {
    UIWindow *window = [self mainWindow];
    //    UIView *rootView = window.rootViewController.view;
    
    MBProgressHUD *hud = nil;
    for ( UIView *view in window.subviews) {
        if (view.tag == 12501 && [view isKindOfClass:[MBProgressHUD class]]) {
            hud = (MBProgressHUD *)view;
            break;
        }
    }
    
    return hud;
}

+ (void)presentHud:(NSString *)greeting {
    [Utility lockUserInteraction];
    if(greeting==nil) greeting = @"正在努力的加载...";
    MBProgressHUD *hud = [self mainWindowHud];
    
    if (hud == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self mainWindow] animated:YES];
        hud.tag = 12501;
        hud.userInteractionEnabled = NO;
        hud.labelText = greeting;
    } else if (hud.hidden) {
        hud.labelText = greeting;
        [hud setHidden:NO];
    }
}

+ (void)dismissHud {
    MBProgressHUD *hud = [self mainWindowHud];
    if (!hud.hidden) {
        [hud setHidden:YES];
        hud = nil;
    }
    [Utility unlockUserInteraction];
}


#pragma mark -
#pragma mark system

+ (BOOL)isRetina {
    BOOL ret = NO;
    if (([UIScreen mainScreen].scale==2.0) && [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]) {
        return YES;
    }
    return ret;
}

+ (UIInterfaceOrientation) screenOrientation {
    //    UIWindow *window = [self mainWindow];
    //    NSLog(@"window orientation: %i", window.rootViewController.interfaceOrientation);
    //    NSLog(@"device orientation: %i", [UIDevice currentDevice].orientation);
    //    NSLog(@"status bar orientation: %i", [UIApplication sharedApplication].statusBarOrientation);
    
    return [UIApplication sharedApplication].statusBarOrientation;
}

// url
+(NSString *)requestURL:(NSString *)api parameters:(NSString *)parmeters{
    NSMutableString *intactURL = [[NSMutableString alloc] init];
    [intactURL appendString:BASE_URL_SCHEME];
    [intactURL appendString:api];
    [intactURL appendString:@"/"];
    if (![@"" isEqualToString:parmeters]) {
        [intactURL appendString:parmeters];
    }
    
    return intactURL;
}

//sound
+(void)playClickSound {
    [ClickSoundManager play];
}

#pragma mark
#pragma mark- email validate
+ (BOOL)validateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validatePassword:(NSString *)password{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}

@end
