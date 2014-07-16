//
//  DFAgreementVCViewController.m
//  JUBADriveing
//
//  Created by nicholas on 14-6-28.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DFAgreementVC.h"

@interface DFAgreementVC ()

@end

@implementation DFAgreementVC

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)theButtonTapped:(id)sender{
    UIButton *button = (UIButton *)sender;
    BOOL agree = YES;
    if (button == agreeBtn)
        agree = YES;
    else
        agree = NO;
     
    if (_delegate && [_delegate respondsToSelector:@selector(agreeSverice:)]) {
        [_delegate agreeSverice:agree];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
