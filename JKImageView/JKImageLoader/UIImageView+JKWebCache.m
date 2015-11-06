//
//  UIImageView+JKWebCache.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "UIImageView+JKWebCache.h"


@implementation UIImageView (JKWebCache)

#pragma mark-Thread
- (void)jk_setImage_ThreadWithURL:(NSURL *)url
{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downLoadImage:) object:url];
    [thread start];
}


- (void)downLoadImage:(NSURL *)url
{
    //在子线程中完成下载
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image == nil){
        //这里可以写下载失败方法
    }else{
        //这里写成功回调， 回调到主线程   这个就是所谓的线程间通讯，除了可以更新主线程的数据外，还可以更新其他线程的比如使用用:performSelector:onThread:withObject:waitUntilDone:
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
        
    }
}

-(void)updateUI:(UIImage*) image
{
    self.image = image;
}


#pragma mark-Operation
- (void)jk_setimage_OperationWithURL:(NSURL *)url
{
    
}



@end
