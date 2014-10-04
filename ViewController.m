//
//  ViewController.m
//  MyoTV
//
//  Created by Christian A. Rodriguez on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import "ViewController.h"
#import <MyoKit/MyoKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"MyoTV";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAccelerometerEvent:)
                                                 name:TLMMyoDidReceiveAccelerometerEventNotification
                                               object:nil];
    // Posted when a new pose is available from a TLMMyo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didReceiveAccelerometerEvent:(NSNotification *)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    switch (pose.type) {
        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest:
            NSLog(@"Hello Myo");
            break;
        case TLMPoseTypeFist:
            NSLog(@"Fist");
            break;
        case TLMPoseTypeWaveIn:
            NSLog(@"Wave In");
            break;
        case TLMPoseTypeWaveOut:
            NSLog(@"Wave Out");
            break;
        case TLMPoseTypeFingersSpread:
            NSLog(@"Fingers Spread");
            break;
        case TLMPoseTypeThumbToPinky:
            NSLog(@"Thumb to Pinky");
            break;
    }
    
}

-(void)didReceivePoseChange:(NSNotification *)notification {
    
}

@end
