//
//  GesturesViewController.h
//  MyoTV
//
//  Created by Abimael Carrasquillo Ayala on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GesturesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end