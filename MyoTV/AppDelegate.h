//
//  AppDelegate.h
//  MyoTV
//
//  Created by Christian A. Rodriguez on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property ViewController *controller; 
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *playInfo; 

@end


