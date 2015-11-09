//
//  TestOperation.m
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestOperation.h"

@interface TestOperation ()
//@property (nonatomic, strong) NSOperationQueue *queue;


@end

@implementation TestOperation

-(void)testInvocationOperation
{
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(opAction) object:nil];
    // 如果使用start，会在当前线程启动操作
    [op1 start];
}


- (void)opAction
{
    NSLog(@"%@",[NSThread currentThread]);
}


- (void)starAsyncThread_Use_NSOperationqueueWith:(UIImageView *)iamgeView
{
    //置空用于重载
    iamgeView.image = nil;
    // 实例化操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    // 初始化一个NSInvocationOperation
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(threadDownLoadImage:) object:iamgeView];
    [queue addOperation:op];
}

- (void)threadDownLoadImage:(UIImageView *)iamgeview
{
    @autoreleasepool {
        NSInteger type = 1;
        //获取网络数据
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(type)?@"http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg":@"http://imgsrc.baidu.com/forum/w%3D580/sign=bbe8c06043166d223877159c76220945/599e9d3df8dcd10054b2bf8a728b4710b8122fcc.jpg"]];
        UIImage *image = [[UIImage alloc]initWithData:data];
        //在主线程更新UI
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            iamgeview.image = image;
        }];
    }
   
}

- (void)startAsyncThread_Use_NSBlockOperationWith:(UIImageView *)imageView;
{
    //置空用于重载
    imageView.image = nil;
    // 实例化操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //初始化一个NSBlockOpration
    NSBlockOperation *opration = [NSBlockOperation   blockOperationWithBlock:^{
        //异步操作
        [self threadDownLoadImage:imageView];
    }];
    //添操作到队列中
    [queue addOperation:opration];
  
}






//线程间依赖关系测速
- (void)testThreadDependencyThread
{
    // 实例化操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    // 并发的线程越多越耗资源，队列可以设置同时并发线程的数量，来进行控制
    queue.maxConcurrentOperationCount = 2;

    //初始化3个操作
    NSBlockOperation *opration1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"耗时操作01 下载 %@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *opration2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"耗时操作02 美化 %@",[NSThread currentThread]);
        
    }];
    
    
    NSBlockOperation *opration3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"耗时操作03 更新 %@",[NSThread currentThread]);
    }];
    //通过添加依赖可以控制线程执行顺序，依赖关系可以多重依赖
    //注意：不要建立循环依赖，会造成死锁
    [opration2 addDependency:opration1];
    [opration3 addDependency:opration2];
    
    //死锁
//    [opration1 addDependency:opration3];

    //直接添加到队列里会并发执行，谁先谁后是系统调用决定
    [queue addOperation:opration2];
    [queue addOperation:opration1];
    [queue addOperation:opration3];
    
    
}



- (void)cancelSomeThread
{
    // 实例化操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    // 并发的线程越多越耗资源，队列可以设置同时并发线程的数量，来进行控制
    queue.maxConcurrentOperationCount = 1;
    
    //初始化3个操作
    
    NSBlockOperation *opration3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"耗时操作03 更新 %@",[NSThread currentThread]);
    }];

    NSBlockOperation *opration1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"耗时操作01 下载 %@",[NSThread currentThread]);
        [opration3 cancel];//线程operation3不会再被执行
    }];
    
    NSBlockOperation *opration2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"耗时操作02 美化 %@",[NSThread currentThread]);
        
    }];

    //通过添加依赖可以控制线程执行顺序，依赖关系可以多重依赖
    //注意：不要建立循环依赖，会造成死锁
    [opration2 addDependency:opration1];
    [opration3 addDependency:opration2];
    
    //死锁
    //    [opration1 addDependency:opration3];
    
    //直接添加到队列里会并发执行，谁先谁后是系统调用决定
    [queue addOperation:opration2];
    [queue addOperation:opration1];
    [queue addOperation:opration3];
    
    
    //    [opration1 setQualityOfService:NSQualityOfServiceUserInteractive];
    
    //    typedef NS_ENUM(NSInteger, NSQualityOfService) {
    //        /* 和图形处理相关的任务，比如滚动和动画 */
    //        NSQualityOfServiceUserInteractive = 0x21,
    //
    //        /* 用户请求的任务，但是不需要精确到毫秒级。例如如果用户请求打开电子邮件App来查看邮件 */
    //        NSQualityOfServiceUserInitiated = 0x19,
    //
    //        /* 周期性的用户请求任务。比如，电子邮件App可能被设置成每5分钟自动检测新邮件。但是在系统资源极度匮乏的时候，将这个周期性的任务推迟几分钟也没有大碍*/
    //        NSQualityOfServiceUtility = 0x11,
    //
    //        /* 后台任务，对这些任务用户可能并不会察觉，比如电子邮件App对邮件进行索引以方便搜索 */
    //        NSQualityOfServiceBackground = 0x09,
    //
    //        /* 默认的优先级 */
    //        NSQualityOfServiceDefault = -1
    //    } NS_ENUM_AVAILABLE(10_10, 8_0);
    
    //    opration1 setQueuePriority:<#(NSOperationQueuePriority)#>
    
}








@end
