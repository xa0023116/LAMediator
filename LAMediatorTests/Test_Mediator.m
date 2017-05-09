//
//  Test_Mediator.m
//  MiaoMoreNew
//
//  Created by Qminlov on 16/8/22.
//  Copyright © 2016年 Qminlov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LAMediator.h"


@interface TestA : NSObject

@property (nonatomic, strong) NSString *test;

- (NSString *) testA;

- (NSString *) testA: (NSString *) paramA  paramB: (NSString *) paramB paramC: (NSString *) paramC;

- (BOOL) nonParam;

- (NSString *) paramNonValue: (NSString *_Nullable) nonValue;

+ (BOOL) staticTestA;

@end

@implementation TestA

- (NSString *) testA {
    return @"TestA";
}

- (NSString *) testA: (NSString *) paramA  paramB: (NSString *) paramB paramC: (NSString *) paramC {
    
    return @"TestAParam";
}

- (BOOL) nonParam {
    return true;
}

- (NSString *) paramNonValue: (NSString *_Nullable) nonValue {
    return nonValue;
}

+ (BOOL) staticTestA {
    return true;
}

@end


@interface TestB : TestA

- (NSString *) testB;

+ (BOOL) staticTestB;

@end

@implementation TestB

- (NSString *) testB {
    return @"TestB";
}

+ (BOOL) staticTestB {
    return true;
}

@end

@interface Test_Mediator : XCTestCase

@end

@implementation Test_Mediator


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - 实例方法(无参数，和参数传空)
- (void) testInstanceFunc {
    /* 调用普通的方法 */
    NSAssert([[[LAMediator sharedInstance] revClass:@"TestA" params:@{@"testA" : kMNonParam}] isEqualToString:@"TestA"], @"调用方法出错");
    /* 调用没有任何参数的方法 */
    NSAssert([[[LAMediator sharedInstance] revClass:@"TestA" params:@{@"nonParam" : kMNonParam}] integerValue] == true, @"无参数调用错误");
    /* 调用参数为空的的方法 */
    NSAssert([[LAMediator sharedInstance] revClass:@"TestA" params:@{@"paramNonValue" : kMNull}] == nil, @"空参数调用错误");
    /* 多参数的方法 */
    BOOL istrue = [[[LAMediator sharedInstance] revClass:@"TestA" params:@{@"testA" : kMNull, @"paramB" : @"AAAAA", @"paramC" : @"CCCC"}] isEqualToString:@"TestAParam"];
    NSAssert(istrue, @"空参数调用错误");
}

#pragma mark - 静态方法 
- (void) testStaticFunc {
    /* 调用静态方法 */
    NSAssert([[[LAMediator sharedInstance] revClass:@"TestA" isStatic:true params:@{@"staticTestA" : kMNonParam} ] integerValue] == true, @"调用静态方法出错");
}

#pragma mark - 属性调用(操作上下文为同一个类)
- (void) testPropertyATest {
    
    // 保证在同一个object 对象下进行操作， 每次[MMMediator sharedInstance] 会根据传入的Object来决定是否要重新创建当前对象
    id object;
    /* 设置Test 的值 AAAAA 然后通过 Get方法 去获得Test*/
     [[LAMediator sharedInstance] revClass:@"TestA" params:@{@"setTest" : @"AAAAA"} object:&object];
     NSAssert([[[LAMediator sharedInstance] revClass:@"TestA" params:@{@"test": kMNonParam} object:&object] isEqualToString:@"AAAAA"], @"Get / Set  获取Test 失败");
}

#pragma mark - 向上寻找(父类)(操作上下文为同一个类)
- (void) testFindFunc {

    id object;
    /* 从子类TestB 里面调用父类实现的testA方法 */
    NSAssert( [[[LAMediator sharedInstance] revClass:@"TestB" params:@{@"testA": kMNonParam} object:&object] isEqualToString:@"TestA"] , @"向上寻找父类失败 实例方法");
    /* 调用testA方法 返回的当前Object 应该是需要创建的TestB  而不是TestA*/
    NSAssert( [[[LAMediator sharedInstance] revClass:@"TestB" params:@{@"testB": kMNonParam} object:&object] isEqualToString:@"TestB"] , @"向上寻找 类型错误应该为TestB");
    /* 调用父类的静态方法*/
    NSAssert( [[[LAMediator sharedInstance] revClass:@"TestB" isStatic:true params:@{@"staticTestA": kMNonParam}] integerValue] == true , @"向上寻找父类失败 静态方法");

}

@end
