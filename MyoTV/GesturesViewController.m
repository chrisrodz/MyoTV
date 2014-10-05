//
//  GesturesViewController.m
//  MyoTV
//
//  Created by Abimael Carrasquillo Ayala on 10/4/14.
//  Copyright (c) 2014 Mai Apps. All rights reserved.
//

#import "GesturesViewController.h"
#import "GesturesTableViewCell.h"

NSArray *gestureImages;
NSArray *gestureTitle;
NSArray *gestureDescription;



@interface GesturesViewController ()

@end

@implementation GesturesViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    gestureImages = [NSArray arrayWithObjects:@"solid_blue_LH_spread_fingers",@"solid_blue_LH_fist",@"solid_blue_LH_pinky_thumb",@"solid_blue_LH_wave_left" ,@"solid_blue_LH_wave_right",nil];
    gestureTitle = [NSArray arrayWithObjects:@"Spread",@"Fist",@"Pinky Thumb",@"Wave Out" ,@"Wave In",nil];
    gestureDescription = [NSArray arrayWithObjects:@"Show program guide",@"Select",@"Exit",@"Rewind" ,@"Forward",nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissTaped:)];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.title = @"MyoGestures";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GesturesTableViewCell" bundle:nil] forCellReuseIdentifier:@"GestureCell"];
    
    GesturesTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"GestureCell"];
    
    NSLog(@"%@", cell);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GesturesTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.Image.image = [UIImage imageNamed:[gestureImages objectAtIndex:indexPath.row]];
    cell.GestureTitle.text = [gestureTitle objectAtIndex:indexPath.row];
    cell.GestureDescription.text = [gestureDescription objectAtIndex:indexPath.row];    
    
    NSLog(@"Enseñando celda");
    
}

-(void)dismissTaped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
