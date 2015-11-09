//
//  TestGCDMethod.m
//  JKImageView
//
//  Created by Jack on 15/11/7.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestGCDMethod.h"

@implementation TestGCDMethod

- (void)testSyncQueue
{
    NSLog(@"主线程----%@",[NSThread mainThread]);
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //获得程序进程缺省产生的并发队列，可设定优先级来选择高、中、低三个优先级队列。由于是系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。需要注意的是，三个队列不代表三个线程，可能会有更多的线程。并发队列可以根据实际情况来自动产生合理的线程数，也可理解为dispatch队列实现了一个线程池的管理，对于程序逻辑是透明的。
    //获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //同步函数:不具备开启新线程的能力
    //添加任务到队列中执行
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    
    NSLog(@"主线程----%@",[NSThread mainThread]);
    
}

- (void)testConcurrentDisQueue
{
//    __weak __typeof__(self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        __strong __typeof(self) strongSelf = weakSelf;
//        [self costTimeMethod];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [strongSelf backToMainThread];
//        });
//    });
    NSLog(@"主线程----%@",[NSThread mainThread]);
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //获得程序进程缺省产生的并发队列，可设定优先级来选择高、中、低三个优先级队列。由于是系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。需要注意的是，三个队列不代表三个线程，可能会有更多的线程。并发队列可以根据实际情况来自动产生合理的线程数，也可理解为dispatch队列实现了一个线程池的管理，对于程序逻辑是透明的。
    //获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
    //异步函数:具备开启新线程的能力
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    
    NSLog(@"主线程----%@",[NSThread mainThread]);

    
}

- (void)costTimeMethod
{
    for (long i = 0; i < 4; i ++) {
        NSLog(@"耗时内容");
//        [NSThread sleepForTimeInterval:1];
    }
}

- (void)backToMainThread
{
       NSLog(@"返回主线程");
}


- (void)testSerialDisQueue
{
    //dispatch_queue_t queue = dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL); //生成一个串行队列，队列中的block按照先进先出（FIFO）的顺序去执行，实际上为单线程执行。第一个参数是队列的名称，在调试程序时会非常有用，所有尽量不要重名了。
    
    //dispatch_queue_t queue = dispatch_queue_create("com.dispatch.concurrent", DISPATCH_QUEUE_CONCURRENT); //生成一个并发执行队列，block被分发到多个线程去执行
    
    NSLog(@"主线程----%@",[NSThread mainThread]);
    dispatch_queue_t queue = dispatch_queue_create("Jack", DISPATCH_QUEUE_SERIAL); // 创建
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性 可以传NULL 默认为串行，若传DISPATCH_QUEUE_CONCURRENT 则表示病行  队列，传DISPATCH_QUEUE_SERIAL则是串行队列
    NSLog(@"下载图片0----%@",[NSThread currentThread]);

    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    NSLog(@"下载图片4----%@",[NSThread currentThread]);

}



@end
