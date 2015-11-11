//
//  UIImage+JKMultiFormat.h
//  JKImageView
//
//  Created by Jack on 15/11/11.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JKMultiFormat)

+ (UIImage *)jk_imageWithData:(NSData *)data;

+ (UIImage *)decodedImageWithImage:(UIImage *)image;


@end
