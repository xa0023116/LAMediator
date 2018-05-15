# JKMediator

[![CI Status](http://img.shields.io/travis/liuweiqiang/JKMediator.svg?style=flat)](https://travis-ci.org/liuweiqiang/JKMediator)
[![Version](https://img.shields.io/cocoapods/v/JKMediator.svg?style=flat)](http://cocoapods.org/pods/JKMediator)
[![License](https://img.shields.io/cocoapods/l/JKMediator.svg?style=flat)](http://cocoapods.org/pods/JKMediator)
[![Platform](https://img.shields.io/cocoapods/p/JKMediator.svg?style=flat)](http://cocoapods.org/pods/JKMediator)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JKMediator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JKMediator"
```

## Support
```ruby
## URLRoute 
    [[LAMediator sharedInstance] routeURL:@"JKdoctor/JKViewController?testA=10&testB=20"];
```

```ruby
## Runtime  支持静态方法和实例方法， 对象，Block参数等，对象持续性操作
    [[LAMediator sharedInstance]revClass:@"JKViewController" isStatic:NO 
    params:@{@"testA":@"1",@"testB":@"2"}]; 
```

##  Test

Test_Mediator


## Author

Qminlov

## License

JKMediator is available under the MIT license. See the LICENSE file for more info.
