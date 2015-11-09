//
//  TestSyncThread.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestSyncThread.h"

@interface TestSyncThread ()
{
    int tickets;
    int count;
    NSThread* ticketsThreadone;
    NSThread* ticketsThreadtwo;
    NSCondition* ticketsCondition;
    NSLock *theLock;
}

@end

@implementation TestSyncThread


- (void)startSyncThreadTest
{
    
    tickets = 100;
    count = 0;
    theLock = [[NSLock alloc] init];
    // 锁对象
    ticketsCondition = [[NSCondition alloc] init];
    ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
    
    
    ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadtwo setName:@"Thread-2"];
    [ticketsThreadtwo start];
}



- (void)starThreadWith:(UIImageView *)imageView
{
    
    imageView.image = nil;
    //1.类方法，直接新建线程调用某个耗时操作，新线程创建后会直接启动该线程
//    [NSThread detachNewThreadSelector:@selector(threadLoadImage:) toTarget:self withObject:imageView];
    
//     2.成员方法，新建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadLoadImage:) object:imageView];
//     需要调用start方法来手动启动线程
    [thread start];
    
//    // 3.使用NSObject的类目方法，performSelectorInBackground 会新建一个后台线程，并在该线程中执行调用的方法
//    [self performSelectorInBackground:@selector(threadLoadImage) withObject:imageView];

    
    
}

- (void)threadLoadImage:(UIImageView *)iamgeview
{
    
    //如果是大内存操作的话 就加上autoreleasepool
    @autoreleasepool {
        NSInteger type = 0;
        //获取网络数据
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(type)?@"http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg":@"http://imgsrc.baidu.com/forum/w%3D580/sign=bbe8c06043166d223877159c76220945/599e9d3df8dcd10054b2bf8a728b4710b8122fcc.jpg"]];
        UIImage *image = [[UIImage alloc]initWithData:data];
        [iamgeview performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
    }

}


- (void)run{
    while (TRUE) {
        // 上锁
//        [ticketsCondition lock];
        [theLock lock];
        if(tickets >= 0){
            [NSThread sleepForTimeInterval:0.09];
            count = 100 - tickets;
            NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
            tickets--;
        }else{
            break;
        }
        [theLock unlock];
//        [ticketsCondition unlock];
    }
}




@end
