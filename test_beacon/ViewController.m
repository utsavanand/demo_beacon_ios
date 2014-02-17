//
//  ViewController.m
//  test_beacon
//
//  Created by utsavanand on 17/02/14.
//  Copyright (c) 2014 Utsav Anand. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "ESTBeaconDefinitions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    bcnMgr = [[ESTBeaconManager alloc] init];
    bcnMgr.delegate = self;
    bcnMgr.avoidUnknownStateBeacons = YES;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"TEST NOTE";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
    [bcnMgr startMonitoringForRegion:region];
    
    [bcnMgr requestStateForRegion:region];
    countLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 100)];
    countLbl.text = @"Count=0";
    countLbl.font = [UIFont systemFontOfSize:30];
    
    closestMajor = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 200, 100)];
    closestMajor.text = @"Major - None";
    closestMajor.font = [UIFont systemFontOfSize:20];
    
    enterBcn = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 200, 200)];
    enterBcn.text = @"Entered - None";
    enterBcn.font = [UIFont systemFontOfSize:20];
    
    exitBcn = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, 200, 200)];
    exitBcn.text = @"Exited - None";
    exitBcn.font = [UIFont systemFontOfSize:20];

    [self.view addSubview:countLbl];
    [self.view addSubview:closestMajor];
    [self.view addSubview:enterBcn];
    [self.view addSubview:exitBcn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [bcnMgr startRangingBeaconsInRegion:region];

}

-(void)resignActive:(id)sender{
    NSLog(@"APPS ENTERS BACKGROUND");
}

-(void)beaconManager:(ESTBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(ESTBeaconRegion *)region
{
    self.view.backgroundColor = [UIColor orangeColor];
    NSLog(@"CHANGE IN STATE");
}

-(void)beaconManager:(ESTBeaconManager *)manager
      didEnterRegion:(ESTBeaconRegion *)region
{
    // iPhone/iPad entered beacon zone
    self.view.backgroundColor = [UIColor grayColor];
    NSLog(@"ENTERED REGION");
    enterBcn.text = @"ENTERED A BEACON RANGE";
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Entered a beacon region ";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    
}

-(void)beaconManager:(ESTBeaconManager *)manager
       didExitRegion:(ESTBeaconRegion *)region
{
    // iPhone/iPad left beacon zone
    NSLog(@"EXITED REGION");
    exitBcn.text = @"EXITED A BCN RANGE";

    self.view.backgroundColor= [UIColor purpleColor];
    // present local notification
    
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    self.view.backgroundColor = [UIColor redColor];

    ESTBeacon* closestBeacon;
    
    NSLog(@"COUNT=%lu",(unsigned long)[beacons count]);
    countLbl.text= [NSString stringWithFormat:@"%lu", (unsigned long)[beacons count]];
    
    if([beacons count] > 0)
    {
        self.view.backgroundColor = [UIColor blueColor];
        closestBeacon = [beacons objectAtIndex:0];
        NSLog(@"BEACON=%@, MAJOR=%@, MINOR=%@, UUID=%@, DISTANCE=%@",closestBeacon,closestBeacon.major, closestBeacon.minor,closestBeacon.proximityUUID,closestBeacon.distance
              );
        closestMajor.text =[ NSString stringWithFormat:@"MAJOR=%@",closestBeacon.major];

    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
