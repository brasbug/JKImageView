//
//  UIImageView+JKWebCache.h
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageMarco.h"
@interface UIImageView (JKWebCache)



- (void)jk_setImageWithURL:(NSURL *)url;

- (void)jk_setImageWithURL:(NSURL *)url PlaceHolder:(UIImage* )placdHolder;



@end
