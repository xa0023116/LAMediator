//
//  JKViewController.m
//  JKMediator
//
//  Created by liuweiqiang on 05/31/2017.
//  Copyright (c) 2017 liuweiqiang. All rights reserved.
//

#import "JKViewController.h"
#import <JKMediator/LAMediator.h>
@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LAMediator sharedInstance]revClass:@"JKViewController" isStatic:NO params:@{@"testA":@"1",
                                                                                  @"testB":@"2"
                                                                                  }]; 
    
    
    [[LAMediator sharedInstance] routeURL:@"JKdoctor/JKViewController?testA=10&testB=20"];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)testA:(NSString *)testA testB:(NSString *)testB{
    
    NSLog(@"%@-%@",testA,testB);
}

@end
