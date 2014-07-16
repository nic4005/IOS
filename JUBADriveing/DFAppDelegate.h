//
//  DFAppDelegate.h
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFTabbarVC.h"
#import "BMKMapManager.h"

@interface DFAppDelegate : UIResponder <UIApplicationDelegate>
{
        BMKMapManager *_mapManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DFTabbarVC *viewController;

@end
