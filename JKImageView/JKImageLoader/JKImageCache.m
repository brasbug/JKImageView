//
//  JKImageCache.m
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "JKImageCache.h"

//png图片签名
static unsigned char jkPNGSignatureBytes[8] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
static NSData *jkPNGSignatureData = nil;

BOOL JKImageDataHasPNGPreffix(NSData *data);

BOOL JKImageDataHasPNGPreffix(NSData *data) {
    NSUInteger pngSignatureLength = [jkPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:jkPNGSignatureData]) {
            return YES;
        }
    }
    
    return NO;
}

FOUNDATION_STATIC_INLINE NSUInteger JKCacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}



@interface JKImageCache ()

@property (nonatomic, strong) NSCache *memCache;
@property (nonatomic, strong) NSString *diskCachePath;
@property (nonatomic, strong) NSOperationQueue  *queueCache;

@property(nonatomic, strong) NSFileManager *fileManager;
@end




@implementation JKImageCache



+(instancetype)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *cacheNameSpace = @"com.Jack.JKImageView";
        jkPNGSignatureData = [NSData dataWithBytes:jkPNGSignatureBytes length:8];
        
        _memCache = [[NSCache alloc]init];
        _memCache.name = cacheNameSpace;
        
        _queueCache = [[NSOperationQueue alloc]init];
        [_queueCache setMaxConcurrentOperationCount:1];
        
        _diskCachePath = [self makeDiskCachePath:cacheNameSpace];
        
        _fileManager = [NSFileManager new];
        
        
    }
    
    return self;
}

// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}



/**
 *  把拿到的图片资源存放到内存缓存中
 *
 *  @param image image
 *  @param key   图片路径
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    if (!image || !key) {
        return;
    }
    
    NSInteger cost = JKCacheCostForImage(image);
    [self.memCache setObject:image forKey:key cost:cost];
    
}


/**
 *  获取缓存中的图片资源
 *
 *  @param key 图片路径
 *
 *  @return 返回图片资源
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key
{
    return [self.memCache objectForKey:key];
}













@end
