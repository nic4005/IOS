//
//  DFNearbyMapVC.m
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DFNearbyMapVC.h"

@interface DFNearbyMapVC ()

@end

@implementation DFNearbyMapVC

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
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, NAVIGATION_SIZE_HEIGHT, 320, [Utility mainWindowBounds].size.height -NAVIGATION_SIZE_HEIGHT-TABBAR_SIZE_HEIGHT)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
