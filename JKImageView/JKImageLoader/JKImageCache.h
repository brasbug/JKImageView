//
//  JKImageCache.h
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKImageCache : NSObject



+(instancetype)shareInstance;

/**
 *  把拿到的图片资源存放到内存缓存中
 *
 *  @param image image
 *  @param key   图片路径
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;


/**
 *  获取缓存中的图片资源
 *
 *  @param key 图片路径
 *
 *  @return 返回图片资源
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;


@end
