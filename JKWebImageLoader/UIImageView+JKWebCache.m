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
#import "JKWebImageManager.h"





@implementation UIImageView (JKWebCache)


-(void)updateUI:(UIImage*) image
{
    self.image = image;
}

- (void)downLoadImage:(NSURL *)url placeHolder:(UIImage *)placdHolder
{
    UIImage *image =  [[JKImageCache shareInstance] imageFromDiskCacheForKey:url.absoluteString];
    if (image) {
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
    }
    else
    {
        @autoreleasepool {
            [self performSelectorOnMainThread:@selector(updateUI:) withObject:placdHolder waitUntilDone:NO];
            //在子线程中完成下载
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            image = [UIImage jk_imageWithData:data];
            [[JKImageCache shareInstance]storeImage:image imageData:data forKey:url.absoluteString toDisk:YES];
            if(image == nil){
                //这里可以写下载失败方法
            }else{
                //这里写成功回调， 回调到主线程   这个就是所谓的线程间通讯，除了可以更新主线程的数据外，还可以更新其他线程的比如使用用:performSelector:onThread:withObject:waitUntilDone:
                [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
            }
        }
    }
}

#pragma mark-MainMethod
- (void)jk_getImageWithURL:(NSURL *)url
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
        [strongSelf downLoadImage:url placeHolder:nil];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operationblock];
}

- (void)jk_oldSetImageWithURL:(NSURL *)url
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
        [strongSelf downLoadImage:url placeHolder:nil];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operationblock];
}

- (void)jk_setImageWithURL:(NSURL *)url
{
    [self jk_setImageWithURL:url PlaceHolder:nil progress:nil completed:nil];
}


- (void)jk_setImageWithURL:(NSURL *)url PlaceHolder:(UIImage* )placdHolder
{
    [self jk_setImageWithURL:url PlaceHolder:placdHolder progress:nil completed:nil];
}




- (void)jk_setImageWithURL:(NSURL *)url
               PlaceHolder:(UIImage *)placdHolder
                  progress:(JKWebImageDownloaderProgressBlock)progressBlock
                 completed:(JKWebImageCompletBlock)completedBlock
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
    __weak __typeof(self)wself = self;
    [[JKWebImageManager sharedManager]downloadImageWithURL:url progress:^(NSInteger receiveSize, NSInteger expecteSize) {
        
        if (progressBlock) {
            progressBlock(receiveSize,expecteSize);
        }
    }  completed:^(UIImage *image, NSError *error, NSURL *imageURL,NSData *dataOrigin) {

        if (!wself) return;
        if (image) {
            [wself performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
        }
        if (completedBlock) {
            completedBlock(image,error,imageURL,dataOrigin);
        }
    }];
}



@end
