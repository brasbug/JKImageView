//
//  UIImageView+JKWebCache.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "UIImageView+JKWebCache.h"
#import "JKImageCache.h"
#import "UIImage+JKMultiFormat.h"






@implementation UIImageView (JKWebCache)


-(void)updateUI:(UIImage*) image
{
    self.image = image;
}

- (void)downLoadImage:(NSURL *)url placeHolder:(UIImage *)placdHolder
{
    UIImage *image =  [[JKImageCache shareInstance] imageFromDiskCacheForKey:url.absoluteString];
    if (image) {
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }
    else
    {
        @autoreleasepool {
            [self performSelectorOnMainThread:@selector(updateUI:) withObject:placdHolder waitUntilDone:YES];
            //在子线程中完成下载
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            image = [UIImage jk_imageWithData:data];
            [[JKImageCache shareInstance]storeImage:image imageData:data forKey:url.absoluteString toDisk:YES];
            if(image == nil){
                //这里可以写下载失败方法
            }else{
                //这里写成功回调， 回调到主线程   这个就是所谓的线程间通讯，除了可以更新主线程的数据外，还可以更新其他线程的比如使用用:performSelector:onThread:withObject:waitUntilDone:
                [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
            }
        }
    }
}

#pragma mark-MainMethod

- (void)jk_setImageWithURL:(NSURL *)url
{
    [self jk_setImageWithURL:url PlaceHolder:nil];
}


- (void)jk_setImageWithURL:(NSURL *)url PlaceHolder:(UIImage* )placdHolder
{
    if ([url isKindOfClass:NSString.class] ) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    if (!url) {
        return;
    }
    //1.创建NSBlockOperation对象
    __weak __typeof__(self) weakSelf = self;
    NSBlockOperation *operationblock = [NSBlockOperation blockOperationWithBlock:^{
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf downLoadImage:url placeHolder:placdHolder];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:5];
    // 1. 一旦将操作添加到操作队列，操作就会启动
    [queue addOperation:operationblock];
}


@end
