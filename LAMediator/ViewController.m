//
//  ViewController.m
//  LAMediator
//
//  Created by Qminlov on 17/5/4.
//  Copyright © 2017年 Qminlov. All rights reserved.
//

#import "ViewController.h"
#import "LAMediator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /// 具体内容请查看Test_Mediator
    [[LAMediator sharedInstance] revClass:@"TestA" count:2 funcs:LA_Func(false, @{@"functionA" : @"AAAA"}), LA_Func(false, @{@"functionB" : @"BBBB"})];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
