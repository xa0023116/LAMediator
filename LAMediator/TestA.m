//
//  TestA.m
//  LAMediator
//
//  Created by Qminlov on 17/5/5.
//  Copyright © 2017年 Qminlov. All rights reserved.
//

#import "TestA.h"

@implementation TestA


- (NSString *) functionA:(NSString *) param {
    NSLog(@"FunctionA :%@", param);
    
    return param;
}

- (NSString *) functionB:(NSString *) param {
    NSLog(@"FunctionB :%@", param);
    return param;
}

@end
