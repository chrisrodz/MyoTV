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
//@property (strong, nonatomic) UIBarButtonItem *refresh;
@property (strong,nonatomic) UIBarButtonItem *gestures;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *playList;
@property NSDictionary *playListInfo;

+ (id)sharedManager; 

-(void)didReceivePoseChange:(NSNotification *)notification;

@end


