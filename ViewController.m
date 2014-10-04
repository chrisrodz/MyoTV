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
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (strong, nonatomic) NSString *listUrl;
@property (strong, nonatomic) NSString *downUrl;
@property (strong, nonatomic) NSString *upUrl;
@property (strong, nonatomic) NSString *selectUrl;
@property (strong, nonatomic) NSString *exitUrl;

@property (strong, nonatomic) NSString *recentChange;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"MyoTV";
    self.connect = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(didTapConnect:)];
    self.navigationItem.rightBarButtonItem = self.connect;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAccelerometerEvent:)
                                                 name:TLMMyoDidReceiveAccelerometerEventNotification
                                               object:nil];
    // Posted when a new pose is available from a TLMMyo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];

    NSString *baseUrl = @"http://172.16.2.109:8080/remote/processKey?key=";
    self.listUrl = [baseUrl stringByAppendingString:@"list"];
    self.downUrl = [baseUrl stringByAppendingString:@"down"];
    self.upUrl = [baseUrl stringByAppendingString:@"up"];
    self.selectUrl = [baseUrl stringByAppendingString:@"select"];
    self.exitUrl = [baseUrl stringByAppendingString:@"exit"];
    NSLog(@"%@", self.listUrl);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapConnect:(id)sender {
    UINavigationController *settingsController = [TLMSettingsViewController settingsInNavigationController];
    
    [self presentViewController:settingsController animated:YES completion:nil];
}

-(void)didReceiveAccelerometerEvent:(NSNotification *)notification {
}

-(void)didReceivePoseChange:(NSNotification *)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    switch (pose.type) {
        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest: {
            NSLog(@"Hello?");
            break;
        }
        case TLMPoseTypeFist: {
            NSLog(@"Fist");
            NSURL *selectUrl = [NSURL URLWithString:self.selectUrl];
            NSURLRequest *selectRequest = [NSURLRequest requestWithURL:selectUrl];
            AFHTTPRequestOperation *selectOperation = [[AFHTTPRequestOperation alloc]initWithRequest:selectRequest];
            selectOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [selectOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error Retrieving Weather");
                
            }];
            
            [selectOperation start];

            break;
        }
        case TLMPoseTypeWaveIn: {
            NSLog(@"Wave In");
            NSURL *upUrl = [NSURL URLWithString:self.upUrl];
            NSURLRequest *upRequest = [NSURLRequest requestWithURL:upUrl];
            AFHTTPRequestOperation *upOperation = [[AFHTTPRequestOperation alloc]initWithRequest:upRequest];
            
            upOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [upOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error Retrieving Weather");
                
            }];
            
            [upOperation start];
            break;
        }
        case TLMPoseTypeWaveOut: {
            NSLog(@"Wave Out");
            NSURL *downUrl = [NSURL URLWithString:self.downUrl];
            NSURLRequest *downRequest = [NSURLRequest requestWithURL:downUrl];
            AFHTTPRequestOperation *downOperation = [[AFHTTPRequestOperation alloc]initWithRequest:downRequest];
            
            downOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [downOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error Retrieving Weather");
                
            }];
            
            [downOperation start];
            break;
        }
        case TLMPoseTypeThumbToPinky: {
            NSLog(@"thumb/pinky");
            NSURL *exit = [NSURL URLWithString:self.exitUrl];
            NSURLRequest *exitRequest = [NSURLRequest requestWithURL:exit];
            AFHTTPRequestOperation *exitOperation = [[AFHTTPRequestOperation alloc]initWithRequest:exitRequest];
            
            exitOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [exitOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                NSLog(@"%@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error Retrieving Weather");
                
            }];
            
            [exitOperation start];
            break;
        }
        case TLMPoseTypeFingersSpread: {
            NSLog(@"Fingers Spread");
            NSURL *list = [NSURL URLWithString:self.listUrl];
            NSURLRequest *listRequest = [NSURLRequest requestWithURL:list];
            AFHTTPRequestOperation *listOperation = [[AFHTTPRequestOperation alloc]initWithRequest:listRequest];
            
            listOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [listOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error Retrieving Weather");
                
            }];
            
            [listOperation start];
            break;
        }
    }
}


@end
