//
//  ViewController.h
//  MyoTV
//
//  Created by Christian A. Rodriguez on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *connect;
@property (strong,nonatomic) UIBarButtonItem *gestures;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


-(void)didReceivePoseChange:(NSNotification *)notification;

@end
