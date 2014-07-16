//
//  DFTabbarVC.h
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DFBaseViewController.h"
#import "DFAgreementVC.h"

@class DFNearbyMapVC;
@class DFOrderVC;
@class DFPreferentialVC;
@class DFSettingVC;

@interface DFTabbarVC : DFBaseViewController<AgreementDelegate>{
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIImageView *tabNearby;
    __weak IBOutlet UIImageView *tabOrder;
    __weak IBOutlet UIImageView *tabPreferential;
    __weak IBOutlet UIImageView *tabSetting;
    
    DFAgreementVC *agreementVC;
    
    // left cover view
    UIView *coverView;
    
    DFNearbyMapVC *nearbyMapViewController;
    DFOrderVC *orderViewController;
    DFPreferentialVC *preferentialViewController;
    DFSettingVC *settingViewController;
    UIImageView *lastTab;

}

@property (strong, readonly, nonatomic) NSArray *controllerArray;
@property (strong, readonly, nonatomic) NSArray *tabsArray;
@property (readonly, nonatomic) NSInteger selectedIndex;
@property (weak, readonly, nonatomic) UIViewController *selectedViewController;
@end
