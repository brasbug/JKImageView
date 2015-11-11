//
//  UIImageView+JKWebCache.h
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImageView (JKWebCache)
//使用Thread 
- (void)jk_setImage_ThreadWithURL:(NSURL *)url;

//使用NSOperation
- (void)jk_setimage_OperationWithURL:(NSURL *)url;

//使用GCD
- (void)jk_setImage_GCDWithURL:(NSURL *)url;

-(void)updateUI:(UIImage*) image;




//默认方法
- (void)jk_setImageWith:(NSURL *)url;



@end
