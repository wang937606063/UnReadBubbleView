//
//  PFViewController.m
//  UnReadBubbleView
//
//  Created by wang937606063 on 04/11/2019.
//  Copyright (c) 2019 wang937606063. All rights reserved.
//

#import "PFViewController.h"
#import "PFSecondViewController.h"
@interface PFViewController ()

@end

@implementation PFViewController
- (IBAction)nextVC:(id)sender {
    PFSecondViewController * secondVC = [[PFSecondViewController alloc]init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
