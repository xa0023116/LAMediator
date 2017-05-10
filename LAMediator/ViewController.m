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
    
    /// 1.远程
    [[LAMediator sharedInstance] routeURL:@"/TestA?functionA=AAAAA2"];
    
    /// 2.本地调用方法
    [[LAMediator sharedInstance] revClass:@"TestA" params:@{@"functionA" : @"AAAA1"} ];

    /// 快捷调用
    LA_REV(@"TestA", LA_Func(false, @{@"functionA" : @"AAAA"}), LA_Func(false, @{@"functionB" : @"BBBB"}));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
