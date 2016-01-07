//
//  UIImage+JKGIF.h
//  JKImageView
//
//  Created by Jack on 15/11/11.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JKGIF)


+ (UIImage *)jk_animatedGIFNamed:(NSString *)name;

+ (UIImage *)jk_animatedGIFWithData:(NSData *)data;

- (UIImage *)jk_animatedImageByScalingAndCroppingToSize:(CGSize)size;



@end
