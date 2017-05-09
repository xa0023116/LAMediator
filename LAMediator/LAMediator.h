//
//  LAMediator.h
//  LAMediator
//
//  Created by Qminlov on 16/6/27.
//  Copyright © 2016年 Qminlov. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 参数传空
#define kMNull @"NULL"
/// 没有参数
#define kMNonParam @"NULLParam"

#define LA_Func( isStatic, param) (@{@"isStatic" : @(isStatic), @"data" : param})

#define LA_REV(clazz, func1, func2)  [[LAMediator sharedInstance] revClass:clazz count:2 funcs:func1, func2];

@interface LAMediator : NSObject

/// 单例
+ (nonnull instancetype) sharedInstance;

#pragma mark -
#pragma mark 远程调用
/**
 *  Routes
 *  URL调用方式，适用于远程调用
 *
 *  @param  URLString 字符串格式: 项目名:// 类名 ? 参数1 = value1 & 参数2 = value2  Note: 参数1 为方法名
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) routeURL: (nonnull NSString *) URLString;

/**
 *  Routes
 *  URL调用方式，适用于远程调用
 *
 *  @param  URLString 字符串格式: 项目名:// 类名 ? 参数1 = value1 & 参数2 = value2  Note: 参数1 为方法名
 *  @param  object    返回反射的对象
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) routeURL: (nonnull NSString *) URLString
                  object: (_Nullable id __strong * _Nullable) object;

#pragma mark -
#pragma mark 本地调用
/**
 *  Localhost
 *  本地调用方式 默认方法名actionFuntion 默认调用实例方法
 *
 *  @param  className 类的名字
 *  @param  params    方法名当做第一个参数名 params 传递 如果参数值空 为 kNull, 没参数 为 kNonParam
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) revClass: (nonnull NSString *) className
                  params: (nonnull NSDictionary *) params;

/**
 *  Localhost
 *  本地调用方式 默认方法名actionFuntion
 *
 *  @param  className 类的名字
 *  @param  isStatic  是否是静态方法 ，默认实例方法
 *  @param  params    方法名当做第一个参数名 params 传递 如果参数值空 为 kNull, 没参数 为 kNonParam
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) revClass: (nonnull NSString *) className
                isStatic: (BOOL) isStatic
                  params: (nonnull NSDictionary *) params;

/**
 *  Localhost
 *  本地调用方式 默认方法名actionFuntion
 *
 *  @param  className 类的名字
 *  @param  params    方法名当做第一个参数名 params 传递 如果参数值空 为 kNull, 没参数 为 kNonParam
 *  @param  object    返回反射的对象
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) revClass: (nonnull NSString *) className
                  params: (nonnull NSDictionary *) params
                  object: (_Nullable id __strong * _Nullable) object;

/**
 *  Localhost
 *  本地调用方式 默认方法名actionFuntion
 *
 *  @param  className 类的名字
 *  @param  isStatic  是否是静态方法 ，默认实例方法
 *  @param  params    方法名当做第一个参数名 params 传递 如果参数值空 为 kNull, 没参数 为 kNonParam
 *  @param  object    返回反射的对象
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) revClass: (nonnull NSString *) className
                isStatic: (BOOL) isStatic
                  params: (nonnull NSDictionary *) params
                  object: (_Nullable id __strong * _Nullable) object;
@end


@interface LAMediator(Shortcut)

/**
 *  Localhost
 *  本地调用方式 连续调多个方法，同一个对象
 *
 *  @param  className 类的名字
 *  @param  count     调用方法次数
 *  @param  funcs     LA_Func
 *
 *  @return 返回方法执行结果 任意对象 无返回值返回nil
 */
- (nullable id) revClass: (nonnull NSString *) className
                   count: (NSInteger) count
                   funcs: (nonnull NSDictionary *) funcs, ...;
@end
