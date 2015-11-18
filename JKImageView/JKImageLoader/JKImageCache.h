//
//  JKImageCache.h
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>


#define JKCacheMaxAge   3600*24*6
#define jKMxCacheSize   0

@interface JKImageCache : NSObject



+(instancetype)shareInstance;


/**
 *  把拿到的图片资源存放到内存缓存中
 *
 *  @param image image
 *  @param key   图片路径
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;


- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;


- (void)storeImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;


/**
 *  获取缓存中的图片资源
 *
 *  @param key 图片路径
 *
 *  @return 返回图片资源
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;



- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;






@end
