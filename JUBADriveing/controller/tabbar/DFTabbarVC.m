//
//  DFTabbarVC.m
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DFTabbarVC.h"
#import "DFNearbyMapVC.h"
#import "DFOrderVC.h"
#import "DFPreferentialVC.h"
#import "DFSettingVC.h"
#import "DFNavigationController.h"
#import "Reachability.h"
#import "DFAgreementVC.h"

#define VIEW_SHIFTING_DURATION 0.2
static const NSInteger TAG_OFFSET = 1000;

@interface DFTabbarVC ()

@end

@implementation DFTabbarVC
@synthesize tabsArray;
@synthesize selectedIndex;
@synthesize controllerArray;
@synthesize selectedViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([Utility isFirstStartApplication]) {
        agreementVC = [Utility controllerFromMainStoryboardWithIdentifier:@"DFAgreementVC"];
        agreementVC.delegate = self;
        [[Utility mainWindow] addSubview:agreementVC.view];
    }else{
        [self setupTabBar];
        [self setupGesture];
        [self selectTabBarIndex:0 animation:NO];
    }
    
    //hide status bar
    if ([self respondsToSelector:SELE(setNeedsStatusBarAppearanceUpdate)]) { //iOS 7
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTabBar{
    
    //nearby
    nearbyMapViewController = [Utility controllerFromMainStoryboardWithIdentifier:@"DFNearbyVC"];
    DFNavigationController *nearbyNav = [[DFNavigationController alloc] initWithRootViewController:nearbyMapViewController];
    [nearbyNav setNavigationBarHidden:YES animated:YES];
    
    //order
    orderViewController = [Utility controllerFromMainStoryboardWithIdentifier:@"DFOrderVC"];
    DFNavigationController *orderNav = [[DFNavigationController alloc] initWithRootViewController:orderViewController];
    [orderNav setNavigationBarHidden:YES animated:YES];
    
    //preferential
    preferentialViewController = [Utility controllerFromMainStoryboardWithIdentifier:@"DFPreferentialVC"];
    DFNavigationController *preferentialNav = [[DFNavigationController alloc] initWithRootViewController:preferentialViewController];
    [preferentialNav setNavigationBarHidden:YES animated:YES];
    
    //setting
    settingViewController = [Utility controllerFromMainStoryboardWithIdentifier:@"DFSettingVC"];
    DFNavigationController *settingNav = [[DFNavigationController alloc] initWithRootViewController:settingViewController];
    [settingNav setNavigationBarHidden:YES animated:YES];
    
    [containerView addSubview:settingNav.view];
    [settingNav.view setFrameX:260];
    
    controllerArray = [NSArray arrayWithObjects:nearbyNav, orderNav, preferentialNav, nil];
    
    tabsArray = [NSArray arrayWithObjects:tabNearby, tabOrder, tabPreferential, nil];
    [self adaptScreen];
}

-(void)setupGesture{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tabTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tabNearby addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tabTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tabOrder addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tabTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tabPreferential addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(lastTabTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tabSetting addGestureRecognizer:tapRecognizer];
}

-(void)adaptScreen{
//    CGFloat imgY = [UIScreen mainScreen].bounds.size.height -62;
//    [tabNearby setFrameY: imgY];
//    [tabOrder setFrameY:imgY];
//    [tabPreferential setFrameY:imgY];
//    [tabSetting setFrameY:imgY];
}

- (void)tabTapped:(UITapGestureRecognizer *)gesture {
    UIImageView *tab = (UIImageView *)gesture.view;
    NSInteger index = tab.tag - TAG_OFFSET;
    if(index==selectedIndex) return;
    
    selectedIndex = index;
    [self selectTabBarIndex:index animation:YES];
}

-(void)lastTabTapped:(UITapGestureRecognizer *)gesture{
    [self moveContainerView];
}

-(void)selectTabBarIndex:(NSUInteger)index animation:(BOOL)animation{
    
    [self updateTabBar:index];
    selectedIndex = index;
    UIViewController *viewController = [controllerArray objectAtIndex:index];
    UIView *targetView = viewController.view;
    
    CGRect moveOutRect = containerView.bounds;
    moveOutRect.origin.x = -moveOutRect.size.width;
    
    CGRect moveInRect = containerView.bounds;
    moveInRect.origin.x = moveInRect.size.width;
    targetView.frame = moveInRect;
    moveInRect.origin.x = 0;
    
    if (targetView.superview == nil) {
        [containerView addSubview:targetView];
    }
    
    if(animation){
        [UIView animateWithDuration:VIEW_SHIFTING_DURATION
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             selectedViewController.view.frame = moveOutRect;
                             targetView.frame = moveInRect;
                         }
                         completion:^(BOOL finished) {
                             selectedViewController = viewController;
                             
                         }];
    }else{
        selectedViewController.view.frame = moveOutRect;
        targetView.frame = moveInRect;
        selectedViewController = viewController;
    }
    
}

#pragma mark
#pragma mark-  move container view
-(void)moveContainerView{
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    coverView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(coverViewTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [coverView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:coverView];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrameX:-260];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)coverViewTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrameX:0];
    } completion:^(BOOL finished) {
        [containerView setFrameX:0];
        [coverView removeFromSuperview];
    }];
}

-(void)updateTabBar:(NSUInteger)index{
    SAFE_ASSIGN_ARRAY(index >=tabsArray.count);
    if (lastTab) {
        [lastTab setHighlighted:NO];
        CGRect rect = lastTab.frame;
        rect.origin.y = lastTab.superview.height - lastTab.image.size.height;
        rect.size = lastTab.image.size;
        lastTab.frame = rect;
    }
    
    UIImageView *newTab = (UIImageView *)[tabsArray objectAtIndex:index];
    [newTab setHighlighted:YES];
    CGRect rect = newTab.frame;
    rect.origin.y = newTab.superview.frame.size.height - newTab.highlightedImage.size.height;
    rect.size = newTab.highlightedImage.size;
    newTab.frame = rect;
    
    lastTab = newTab;
}

#pragma mark - Notification method
-(void)gotoQuick{
    [self selectTabBarIndex:0 animation:YES];
}

-(void)tabBarWillShow:(BOOL)show{
    if (show){
        tabNearby.hidden = NO;
        tabOrder.hidden = NO;
        tabPreferential.hidden = NO;
        tabSetting.hidden = NO;
    }else{
        tabNearby.hidden = YES;
        tabOrder.hidden = YES;
        tabPreferential.hidden = YES;
        tabSetting.hidden = YES;
    }
}


#pragma mark
#pragma mark - agreement delegate
-(void)agreeSverice:(BOOL)agree{
    if (agree) {
        [UIView animateWithDuration:0.5 animations:^{
            agreementVC.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [agreementVC.view removeFromSuperview];
        }];
        [self setupTabBar];
        [self setupGesture];
        [self selectTabBarIndex:0 animation:NO];
    }
}

#pragma mark
#pragma mark  check the network 
//  wifi
- (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != ReachableViaWiFi);
}

// 3g network
- (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != ReachableViaWWAN);
}
@end
