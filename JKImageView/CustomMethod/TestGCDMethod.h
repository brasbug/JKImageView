//
//  TestGCDMethod.h
//  JKImageView
//
//  Created by Jack on 15/11/7.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestGCDMethod : NSObject

//并发队列测试
- (void)testConcurrentDisQueue;
//串行队列测试
- (void)testSerialDisQueue;
//同步函数添加到并发队列中测试
- (void)testSyncQueue;
@end
