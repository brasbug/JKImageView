//
//  UIImageView+JKWebCache.h
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JKWebCache)
//使用Thread 做异步加载图片
- (void)jk_setImage_ThreadWithURL:(NSURL *)url;

- (void)jk_setimage_OperationWithURL:(NSURL *)url;


@end
