//
//  GesturesTableViewCell.h
//  MyoTV
//
//  Created by Abimael Carrasquillo Ayala on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GesturesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *GestureTitle;
@property (weak, nonatomic) IBOutlet UILabel *GestureDescription;

@end
