//
//  UIImageView+JKWebCache.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "UIImageView+JKWebCache.h"
#import "JKImageCache.h"

@implementation UIImageView (JKWebCache)



-(void)updateUI:(UIImage*) image
{
    self.image = image;
}

- (void)downLoadImage:(NSURL *)url
{
    UIImage *image =  [[JKImageCache shareInstance] imageFromMemoryCacheForKey:url.absoluteString];
    if (image) {
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }
    else
    {
        @autoreleasepool {
            //在子线程中完成下载
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *tempimage = [[UIImage alloc]initWithData:data];
            [[JKImageCache shareInstance] storeImage:tempimage forKey:url.absoluteString];
            if(tempimage == nil){
                //这里可以写下载失败方法
            }else{
                //这里写成功回调， 回调到主线程   这个就是所谓的线程间通讯，除了可以更新主线程的数据外，还可以更新其他线程的比如使用用:performSelector:onThread:withObject:waitUntilDone:
                [self performSelectorOnMainThread:@selector(updateUI:) withObject:tempimage waitUntilDone:YES];
            }
        }
    }
}

#pragma mark-MainMethod

- (void)jk_setImageWith:(NSURL *)url
{
    //1.创建NSBlockOperation对象
    __weak __typeof__(self) weakSelf = self;
    NSBlockOperation *operationblock = [NSBlockOperation blockOperationWithBlock:^{
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf downLoadImage:url];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:5];
    // 1. 一旦将操作添加到操作队列，操作就会启动
    [queue addOperation:operationblock];
    
}







@end
