//
//  LAMediator.m
//  LAMediator
//
//  Created by Qminlov on 16/6/27.
//  Copyright © 2016年 Qminlov. All rights reserved.
//

#import "LAMediator.h"
#import <objc/runtime.h>

/// Invocation 返回值判断
static inline id returnValue(NSInvocation * invocation) {
#define WRAP_AND_RETURN(type) \
    do { \
         type val = 0; \
         [invocation getReturnValue:&val]; \
         return @(val); \
    } while (0)
    
    const char *returnType = invocation.methodSignature.methodReturnType;
    // Skip const type qualifier.
    if (returnType[0] == 'r') {
        returnType++;
    }
    
    if (strcmp(returnType, @encode(id)) == 0
        || strcmp(returnType, @encode(Class)) == 0
        || strcmp(returnType, @encode(void (^)(void))) == 0) {
        __autoreleasing id returnObj;
        [invocation getReturnValue:&returnObj];
        return returnObj;
    } else if (strcmp(returnType, @encode(char)) == 0)
    {
        WRAP_AND_RETURN(char);
    } else if (strcmp(returnType, @encode(int)) == 0)
    {
        WRAP_AND_RETURN(int);
    } else if (strcmp(returnType, @encode(short)) == 0)
    {
        WRAP_AND_RETURN(short);
    } else if (strcmp(returnType, @encode(long)) == 0)
    {
        WRAP_AND_RETURN(long);
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(returnType, @encode(unsigned char)) == 0)
    {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(returnType, @encode(unsigned int)) == 0)
    {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(returnType, @encode(unsigned short)) == 0)
    {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(returnType, @encode(unsigned long)) == 0)
    {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0)
    {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(returnType, @encode(float)) == 0)
    {
        WRAP_AND_RETURN(float);
    } else if (strcmp(returnType, @encode(double)) == 0)
    {
        WRAP_AND_RETURN(double);
    } else if (strcmp(returnType, @encode(BOOL)) == 0)
    {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(returnType, @encode(char *)) == 0)
    {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(returnType, @encode(void)) == 0)
    {
        return nil;
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [invocation getReturnValue:valueBytes];
        
        return [NSValue valueWithBytes:valueBytes objCType:returnType];
    }
    
    return nil;
    
#undef WRAP_AND_RETURN
}



#pragma mark -
#pragma mark Routes NSString  分类

@interface NSString(LARoutes)

/**
 *  参数解析
 *
 *  @return 解析 debug=true&foo=bar  返回 key: debug  value: true
 */
- (NSDictionary *) laRoutes_URLParameterDictionary;

@end


@implementation NSString(LARoutes)

/// 参数解析  debug=true&foo=bar
- (NSDictionary *) laRoutes_URLParameterDictionary {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.length
        && [self rangeOfString:@"="].location != NSNotFound) {
        NSArray *keyValuePairsArray = [self componentsSeparatedByString:@"&"];
        
        for (NSString * keyValuePair in keyValuePairsArray) {
            NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
            NSString *paramKey = pair[0];
            id paramValue;
            if (pair.count == 2) {
                paramValue = pair[1];
            } else if (pair.count > 2) {
                NSString *tmpParamValue;
                for (int i = 1; i < pair.count; i ++) {
                    tmpParamValue = [tmpParamValue stringByAppendingString:pair[i]];
                }
                paramValue = tmpParamValue;
            }
            
            [parameters setObject:pair[1] forKey:paramKey];
        }
    }
    return parameters;
}

@end

@interface LAMediator()
/**
 *  反射方法
 *
 *  @param  className  类名
 *  @param  params     参数
 *  @param  object     返回 当前反射出来的对象
 *  @param  error      错误消息
 *
 *  @return 任意对象
 */
- (nullable id) revTarget: (nonnull NSString *) className
                   params: (nonnull id) params
                 isStatic: (BOOL) isStatic
                   object: (_Nullable id __strong *) object
                    error: ( __autoreleasing NSError * _Nullable *) error;

/**
 *  查询方法，并进行消息转发，返回结果
 *
 *  @param  className  类名
 *  @param  params     参数
 *  @param  result (selFuncName, selParamsArray, isStatic) 返回查询到的结果 selFuncName 查询到的方法名, selParamsArray 查询到方法参数数组, isStatic 是否是静态方法
 *
 *  @return 反射后进行消息转发返回的结果
 */
- (id) selName: (nonnull NSString *) className
        params: (nonnull NSDictionary *) params
      isStatic: (BOOL) isStatic
        result: (nullable id (^)( NSString * _Nullable selFuncName, NSArray * _Nullable selParamsArray, BOOL isStatic)) result;

/*
 *  查询方法
 *
 *  @param  className 类名
 *  @param  isStatic  是否是静态方法
 *  @param  funcInfoBlock(funcName) 循环找到当前的方法
 *
 *  @return
 */
- (void) selFunc: (nonnull NSString *) className
        isStatic:(BOOL) isStatic
        funcInfo:(BOOL(^)(NSString *funcName)) funcInfoBlock;


@end

@implementation LAMediator

+ (nonnull instancetype) sharedInstance {
    static LAMediator *laMediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        laMediator = [[LAMediator alloc] init];
    });
    
    return laMediator;
}

#pragma mark -
#pragma mark 远程调用

- (nullable id) routeURL: (nonnull NSString *) URLString {
    id object;
    return [self routeURL:URLString isStatic:false object:&object];
}

- (nullable id) routeURL: (nonnull NSString *) URLString
                isStatic: (BOOL) isStatic
                  object: (_Nullable id __strong * _Nullable) object {
    
    NSString *urlParam = [[URLString componentsSeparatedByString:@"/"] lastObject];
    NSArray *array     = [urlParam componentsSeparatedByString:@"?"];
    NSString *clazz    = [array firstObject];
    if (clazz) {
        NSString *param = [array lastObject];
        return [self revClass:clazz isStatic:isStatic params:[param laRoutes_URLParameterDictionary] object:object];
    }
    
    return nil;
}


#pragma mark -
#pragma mark 本地调用

- (nullable id) revClass: (nonnull NSString *) className
                  params: (nonnull NSDictionary *) params {
    id object;
    return [self revClass:className params:params object:&object];
}

- (nullable id) revClass: (nonnull NSString *) className
                isStatic: (BOOL) isStatic
                  params: (nonnull NSDictionary *) params {
    id object;
    return [self revClass:className isStatic:isStatic params:params object:&object];
}

- (nullable id) revClass: (nonnull NSString *) className
                  params: (nonnull NSDictionary *) params
                  object: (_Nullable id __strong * _Nullable) object {
    return [self revClass:className isStatic:false params:params object:object];
}

- (nullable id) revClass: (nonnull NSString *) className
                isStatic: (BOOL) isStatic
                  params: (nonnull NSDictionary *) params
                  object: (_Nullable id __strong * _Nullable) object {
    NSError *error;
    id resultObject = [self revTarget:className params:params isStatic:isStatic object:object error:&error];
    if (error == nil) return resultObject;
    
    NSLog(@"LAMediator Error Message :%@", error.domain);
    
    return nil;
}

/// 反射对象
- (nullable id) revTarget: (nonnull NSString *) className
                   params: (nonnull NSDictionary *) params
                 isStatic: (BOOL) isStatic
                   object: (_Nullable id __strong *) object
                    error: (__autoreleasing NSError * _Nullable *) error {
    Class clazz = NSClassFromString(className);
    
    if (clazz != nil)
    {
        return [self selName:className
                      params:params
                    isStatic:isStatic
                      result:^id(NSString * _Nullable selFuncName, NSArray * _Nullable selParamsArray, BOOL isStatic) {
                          
                          if (selFuncName != nil) {
                              
                              if ( isStatic && [selFuncName isEqualToString:@"new"]) return [clazz new];
                              if ( isStatic && [selFuncName isEqualToString:@"alloc"]) return [clazz alloc];
                              
                              SEL action = NSSelectorFromString(selFuncName);
                              
                              // 反射
                              NSInvocation *invocation;
                              if (isStatic) {
                                  NSMethodSignature *methodSignature = [objc_getClass([className cStringUsingEncoding:NSUTF8StringEncoding]) methodSignatureForSelector:action];
                                  invocation        = [NSInvocation invocationWithMethodSignature:methodSignature];
                                  
                                  Class metaClass   = objc_getMetaClass([className cStringUsingEncoding:NSUTF8StringEncoding]);
                                  invocation.target = (id)[metaClass alloc];
                              } else {
                                  id target;
                                  
                                  if (*object != nil) {
                                      target  = *object;
                                  } else {
                                      target  = [[clazz alloc] init];
                                      *object = target;
                                  }
                                  
                                  invocation  = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
                                  invocation.target = target;
                              }
                              
                              invocation.selector = action;
                              // 有参数
                              if (selParamsArray != nil) {
                                  // NSInvocation 的初始参数为2,  0 为 target , 1 为 selector
                                  int i = 2;
                                  for (NSString *param in selParamsArray) {
                                      id paramObject = params[param]; // 这一步是必要的，防止直接跟C 类型直接比较 而引发崩溃
                                      if ([kMNull isEqualToString:paramObject])  paramObject = nil;
   
                                      [invocation setArgument:&paramObject atIndex:i];
                                      i++;
                                  }
                              }

                              [invocation invoke];
                              
                              return returnValue(invocation);
                          } else {
                              if (error != nil) *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"%@ Function not found", className] code:101 userInfo:nil];
                          }
                
                          return nil;
                      }];
    } else {
        if (error != nil)  *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"%@ Class not fount", className] code:102 userInfo:nil];
    }
    
    return nil;
}

#pragma mark -
#pragma mark 查询方法

/// 检测方法
- (void) selFunc: (nonnull NSString *) className
        isStatic:(BOOL) isStatic
        funcInfo:(BOOL(^)(NSString *funcName)) funcInfoBlock{
    
    Class clazz = NSClassFromString(className);
    do {
        Class tempClazz = clazz; // 取实例方法还是静态方法
        if (isStatic) tempClazz = objc_getMetaClass([[NSString stringWithFormat:@"%@",clazz] UTF8String]);
        
        unsigned int outCount;
        Method *methods = class_copyMethodList(tempClazz, &outCount);
        
        for (unsigned int i = 0; i < outCount; i++) {
            Method method = methods[i];
            SEL methodSEL = method_getName(method);
            if (funcInfoBlock([NSString stringWithUTF8String:sel_getName(methodSEL)])) {
                free(methods);
                return;
            }
        }
        free(methods);
    } while ((clazz = [clazz superclass])); // 向上寻找父类
}

#pragma mark -
#pragma mark - Private  NSInvocation Support

/// 查找方法名
- (nullable id) selName: (nonnull NSString *) className
                 params: (nonnull NSDictionary *) params
               isStatic: (BOOL) isStatic
                 result: (nullable id (^)( NSString * _Nullable selFuncName, NSArray * _Nullable selParamsArray, BOOL isStatic)) result {

    if (params == nil || [params count] == 0) return result(nil, nil, false);
    
    NSArray * paramsArray = params.allKeys;
    NSMutableSet * paramsSet = [[NSMutableSet alloc] initWithArray:paramsArray];
    
    __block NSString *_funcName;
    __block NSMutableArray *_funcParamsArray;
    
    [self selFunc:className isStatic:isStatic funcInfo:^BOOL(NSString *funcName) {
        /*
         *  1.根据方法名:进行拆分  根据拆分确定是否带有参数isParams(无参方法和有参数方法)
         *  2.将拆分数组转换成Set(实际从类中反射出来的方法名) 跟 params 字典转成的Set(使用者参数传递过来的方法名)进行 求差集
         *  3.找到返回方法名(确定 无参数 OR 有参数, 静态 OR 实例 和参数名完全一致)，以及方法对应参数
         */
        
        // 转换
        NSMutableArray * selectorParamsArray = [[NSMutableArray alloc] initWithArray:[funcName componentsSeparatedByString:@":"]];
        
        BOOL isParams = false;
        if ([selectorParamsArray count] > 1
            && [selectorParamsArray.lastObject isEqual:@""]) {
            [selectorParamsArray removeLastObject];
            isParams = true;
        }
        
        NSMutableSet *selecotrSet = [[NSMutableSet alloc] initWithArray:selectorParamsArray];
        NSMutableSet *tempParamsSet = [paramsSet mutableCopy];
        // 匹配
        if ([tempParamsSet isEqualToSet:selecotrSet]) {
            id firstValue = [[params allValues] firstObject];
            
            // 如果是没有参数
            if ( [firstValue respondsToSelector:@selector(isEqualToString:)]
                && [firstValue isEqualToString:kMNonParam] ) {
                if (isParams == false) {
                    _funcName = funcName;
                    return true;
                }
            } else if (isParams == true) {
                _funcName = funcName;
                _funcParamsArray = selectorParamsArray;
                return true;
            }
        }
        return false;
    }];
    
    return result(_funcName, _funcParamsArray, isStatic);
}

@end

@implementation LAMediator(Shortcut)

- (nullable id) revClass: (nonnull NSString *) className
                   count: (NSInteger) count
                   funcs: (nonnull NSDictionary *) funcs, ... {
    __block id returnObject;
    __block id object;
    
    void(^callMethods)(NSDictionary *dic) = ^(NSDictionary *dic){
        BOOL isStatic = [dic[@"isStatic"] boolValue];
        returnObject = [[LAMediator sharedInstance] revClass:className isStatic:isStatic params:dic[@"data"] object:&object];
    };
    
    if (funcs != nil) {
        callMethods(funcs);
        
        va_list args;
        va_start(args, funcs);
        
        id dict;
        while ((--count)) {
            dict = va_arg(args, id);
            callMethods(dict);
        }
        
        va_end(args);
    }
    return returnObject;
}

@end

