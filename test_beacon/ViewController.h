//
//  ViewController.h
//  test_beacon
//
//  Created by utsavanand on 17/02/14.
//  Copyright (c) 2014 Utsav Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeaconManager.h"
#import "ESTBeacon.h"

@interface ViewController : UIViewController <ESTBeaconDelegate, ESTBeaconManagerDelegate>{
    ESTBeaconManager *bcnMgr;
    UILabel *countLbl;
    UILabel *closestMajor;
    UILabel *enterBcn;
    UILabel *exitBcn;
}

@end
