//
//  PFSecondViewController.m
//  UnReadBubbleView_Example
//
//  Created by wangpengfei on 2019/4/11.
//  Copyright © 2019 wang937606063. All rights reserved.
//

#import "PFSecondViewController.h"
#import <UnReadBubbleView/UnReadBubbleView.h>
@interface PFSecondViewController ()

@end

@implementation PFSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UnReadBubbleView * readView =[[UnReadBubbleView alloc]initWithFrame:CGRectMake(100, 100, 30, 30)];
    readView.bubbleLabel.font = [UIFont systemFontOfSize:12];
    readView.bubbleLabel.text = @"99+";
    readView.backBlock = ^{
        
    };
    readView.bubbleColor = [UIColor redColor];
    
    [self.view addSubview:readView];
}

@end
