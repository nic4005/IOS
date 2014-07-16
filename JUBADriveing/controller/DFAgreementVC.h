//
//  DFAgreementVCViewController.h
//  JUBADriveing
//
//  Created by nicholas on 14-6-28.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DFBaseViewController.h"

@protocol AgreementDelegate <NSObject>

-(void)agreeSverice:(BOOL)agree;

@end

@interface DFAgreementVC : DFBaseViewController{
    __weak IBOutlet UIButton *agreeBtn;
    __weak IBOutlet UIButton *refuseBtn;
}

@property(nonatomic, assign)id<AgreementDelegate>delegate;

@end
