//
//  DFNearbyMapVC.h
//  JUBADriveing
//
//  Created by nicholas on 14-6-22.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DFBaseViewController.h"
#import "BMKMapView.h"

@interface DFNearbyMapVC : DFBaseViewController<BMKMapViewDelegate>
{
    BMKMapView *mapView;
}
@end
