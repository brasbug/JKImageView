//
//  TestOperation.h
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestOperation : NSObject

//- 直接启动一个NSInvocationOperation
-(void)testInvocationOperation;

//- (void)starAsyncThread_Use_NSOperationqueue;
//- 使用NSOperationQueue管理NSOperation并开启一个异步线程
- (void)starAsyncThread_Use_NSOperationqueueWith:(UIImageView *)iamgeView;

//- 使用NSOperationQueue管理并NSBlockOperation开启一个线程
- (void)startAsyncThread_Use_NSBlockOperationWith:(UIImageView *)imageView;

//线程间依赖关系测速
- (void)testThreadDependencyThread;

//取消某一个还未执行的线程
- (void)cancelSomeThread;

@end
