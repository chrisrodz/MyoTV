//
//  ViewController.m
//  MyoTV
//
//  Created by Christian A. Rodriguez on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import "ViewController.h"
#import <MyoKit/MyoKit.h>
#import "CustomCell.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (strong, nonatomic) NSString *listUrl;
@property (strong, nonatomic) NSString *downUrl;
@property (strong, nonatomic) NSString *upUrl;
@property (strong, nonatomic) NSString *selectUrl;
@property (strong, nonatomic) NSString *exitUrl;

@property (strong, nonatomic) NSString *ffwdUrl;
@property (strong, nonatomic) NSString *rewUrl;
@property (strong, nonatomic) NSString *playUrl;
@property (nonatomic) BOOL isFastForwarding;
@property (nonatomic) BOOL isRewinding;

@property (strong, nonatomic) TLMPose *currentPose;
@property (nonatomic) double baseRollAngle;
@property (nonatomic) double baseYawAngle;

@end

@implementation ViewController

+ (id)sharedManager {
    static ViewController *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"MyoTV";
    self.connect = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(didTapConnect:)];
    self.navigationItem.rightBarButtonItem = self.connect;
    
    self.refresh = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(didTapRefresh:)];
    self.navigationItem.leftBarButtonItem = self.refresh;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveOrientationEvent:)
                                                 name:TLMMyoDidReceiveOrientationEventNotification
                                               object:nil];
    // Posted when a new pose is available from a TLMMyo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];

    NSString *baseUrl = @"http://172.16.2.109:8080/remote/processKey?key=";
    NSString *getBaseURL = @"http://172.16.2.109:8080/dvr/playList?action=";
    self.listUrl = [baseUrl stringByAppendingString:@"list"];
    self.downUrl = [baseUrl stringByAppendingString:@"down"];
    self.upUrl = [baseUrl stringByAppendingString:@"up"];
    self.selectUrl = [baseUrl stringByAppendingString:@"select"];
    self.exitUrl = [baseUrl stringByAppendingString:@"exit"];
    self.playList = [getBaseURL stringByAppendingString:@"get"];
    
    self.ffwdUrl = [baseUrl stringByAppendingString:@"ffwd"];
    self.rewUrl = [baseUrl stringByAppendingString:@"rew"];
    self.playUrl = [baseUrl stringByAppendingString:@"play"];

    self.isRewinding = NO;
    self.isFastForwarding = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapConnect:(id)sender {
    UINavigationController *settingsController = [TLMSettingsViewController settingsInNavigationController];
    
    [self presentViewController:settingsController animated:YES completion:nil];
}

- (void)didTapRefresh:(id)sender {
    [self viewDidLoad];
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSLog(@"DICT: %@", self.playListInfo);
    NSLog(@"DICT 2: %@", del.playInfo);
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView setNeedsLayout];
}

-(void)didReceiveOrientationEvent:(NSNotification *)notification {
    // Retrieve the orientation from the NSNotification's userInfo with the kTLMKeyOrientationEvent key.
    TLMOrientationEvent *orientationEvent = notification.userInfo[kTLMKeyOrientationEvent];
    
    // Create Euler angles from the quaternion of the orientation.
    TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
    
    if (self.isFastForwarding == NO && self.isRewinding == NO) {
        self.baseYawAngle = angles.yaw.degrees;
    } else if (self.isFastForwarding) {
        if (angles.yaw.degrees < self.baseYawAngle - 30) {
            [self sendFastforward];
            self.baseYawAngle = angles.yaw.degrees;
        }
    } else if (self.isRewinding) {
        if (angles.yaw.degrees > self.baseYawAngle + 30) {
            [self sendRewind];
            self.baseYawAngle = angles.yaw.degrees;
        }
    }
}

-(void)didReceiveAccelerometerEvent:(NSNotification *)notification {
}

-(void)didReceivePoseChange:(NSNotification *)notification {

    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    
    if (self.isRewinding == YES || self.isFastForwarding == YES) {
        self.isFastForwarding = NO;
        self.isRewinding = NO;
        [self sendPlay];
    }
    
    self.currentPose = pose;
    
    switch (pose.type) {
        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest: {
            NSLog(@"Rest");
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
            
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startRewind:) userInfo:nil repeats:NO];
            
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
            
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startFastForward:) userInfo:nil repeats:NO];
            
            break;
        }
        case TLMPoseTypeThumbToPinky: {
            [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(verifyPinky) userInfo:nil repeats:NO];
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

- (void)startFastForward:(id) sender {
    if (self.currentPose.type == TLMPoseTypeWaveOut) {
        self.isFastForwarding = YES;
        [self sendFastforward];
    }
}

- (void)sendFastforward {
    NSLog(@"Fast forward");
    NSURL *selectUrl = [NSURL URLWithString:self.ffwdUrl];
    NSURLRequest *selectRequest = [NSURLRequest requestWithURL:selectUrl];
    AFHTTPRequestOperation *selectOperation = [[AFHTTPRequestOperation alloc]initWithRequest:selectRequest];
    selectOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [selectOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error fast forwarding");
        
    }];
    
    [selectOperation start];
}

- (void)startRewind:(id) sender {
    if (self.currentPose.type == TLMPoseTypeWaveIn) {
        self.isRewinding = YES;
        [self sendRewind];
    }
}

- (void)sendRewind {
    NSLog(@"Rewind");
    NSURL *selectUrl = [NSURL URLWithString:self.rewUrl];
    NSURLRequest *selectRequest = [NSURLRequest requestWithURL:selectUrl];
    AFHTTPRequestOperation *selectOperation = [[AFHTTPRequestOperation alloc]initWithRequest:selectRequest];
    selectOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [selectOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error rewinding");
        
    }];
    
    [selectOperation start];
}

- (void)sendPlay {
    NSURL *selectUrl = [NSURL URLWithString:self.playUrl];
    NSURLRequest *selectRequest = [NSURLRequest requestWithURL:selectUrl];
    AFHTTPRequestOperation *selectOperation = [[AFHTTPRequestOperation alloc]initWithRequest:selectRequest];
    selectOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [selectOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error Playing");
        
    }];
    
    [selectOperation start];
}

- (void)verifyPinky {
    if (self.currentPose.type == TLMPoseTypeThumbToPinky) {
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
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSDictionary *temporary = [[NSDictionary alloc]init]; 
    temporary = [del.playInfo valueForKey:@"updates"];
    return [[temporary valueForKey:@"title"] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    CustomCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *temporary = [[NSArray alloc]init];
    temporary = [delegate.playInfo valueForKey:@"updates"];
    NSLog(@"Dict temp2: %@", [temporary valueForKey:@"episodeTitle"]);
    @try {
        cell.Title.text = [[temporary objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    @catch (NSException *exception) {
        if ([temporary valueForKey:@"title"] == nil){
            cell.Title.text = @"NIL";
        }
    }
    NSLog(@"%@", cell);
    
    return cell;
}


@end
