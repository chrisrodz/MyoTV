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

@property (strong, nonatomic) NSDictionary *JSONlist;
@property (strong, nonatomic) NSDictionary *JSONdown;
@property (strong, nonatomic) NSDictionary *JSONup;
@property (strong, nonatomic) NSDictionary *JSONselect;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSString *baseUrl = @"http://172.16.2.109:8080/remote/processKey?key=";
    self.listUrl = [baseUrl stringByAppendingString:@"list"];
    self.downUrl = [baseUrl stringByAppendingString:@"down"];
    self.upUrl = [baseUrl stringByAppendingString:@"up"];
    self.selectUrl = [baseUrl stringByAppendingString:@"select"];
    NSLog(@"%@", self.listUrl);
    
    NSURL *list = [NSURL URLWithString:self.listUrl];
    NSURL *down = [NSURL URLWithString:self.downUrl];
    NSURL *up = [NSURL URLWithString:self.upUrl];
    NSURL *select = [NSURL URLWithString:self.selectUrl];
    
    NSURLRequest *listRequest = [NSURLRequest requestWithURL:list];
    NSURLRequest *downRequest = [NSURLRequest requestWithURL:down];
    NSURLRequest *upRequest = [NSURLRequest requestWithURL:up];
    NSURLRequest *selectRequest = [NSURLRequest requestWithURL:select];
    
    AFHTTPRequestOperation *operationList = [[AFHTTPRequestOperation alloc]initWithRequest:listRequest];
    operationList.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationList setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operationList, NSError *error) {
        
        NSLog(@"Error Retrieving Weather");
        
    }];

    [operationList start];
    
    AFHTTPRequestOperation *operationDown = [[AFHTTPRequestOperation alloc]initWithRequest:downRequest];
    operationDown.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationDown setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operationDown, NSError *error) {
        
        NSLog(@"Error Retrieving Weather");
        
    }];
    
    [operationDown start];
    
    AFHTTPRequestOperation *operationUp = [[AFHTTPRequestOperation alloc]initWithRequest:upRequest];
    operationUp.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationUp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operationUp, NSError *error) {
        
        NSLog(@"Error Retrieving Weather");
        
    }];
    
    [operationUp start];
    
    AFHTTPRequestOperation *operationSelect = [[AFHTTPRequestOperation alloc]initWithRequest:selectRequest];
    operationSelect.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationSelect setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operationList, NSError *error) {
        
        NSLog(@"Error Retrieving Weather");
        
    }];
    
    [operationSelect start];
    
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
