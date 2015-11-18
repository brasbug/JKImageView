//
//  JKImageCache.m
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "JKImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+JKMultiFormat.h"


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
        
        //把数据写入disk
        _fileManager = [NSFileManager new];
        
        //关闭应用的时候会清理过期文件
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDiskFile)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        
    }
    
    return self;
}

// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)defaultCachePathForKey:(NSString *)key
{
    NSString *fileName = self.diskCachePath.mutableCopy;
   return  [fileName stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
}



/**
 *  把拿到的图片资源存放到内存缓存中
 *
 *  @param image image
 *  @param key   图片路径
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self storeImage:image forKey:key toDisk:YES];
    
}


- (void)storeImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!image || !key) {
        return;
    }
    NSInteger cost = JKCacheCostForImage(image);
    [self.memCache setObject:image forKey:key cost:cost];
    
    if (toDisk) {
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSData *data = imageData;
            if (!data) {
                //在这里损失了GIF质量
                BOOL imageISPNG = YES;
                if ([imageData length]>=[jkPNGSignatureData length]) {
                    imageISPNG = JKImageDataHasPNGPreffix(imageData);
                }
                if (imageISPNG) {
                    data = UIImagePNGRepresentation(image);
                }
                else
                {
                    data = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                }
            }
            if (data) {
                if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                    [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                
                [_fileManager createFileAtPath:[self defaultCachePathForKey:key] contents:data attributes:nil];
            }
        }];
        [self.queueCache addOperation:operation];
        
    }
}




- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    [self storeImage:image imageData:nil forKey:key toDisk:YES];
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


- (UIImage *)imageFromDiskCacheForKey:(NSString *)key
{
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    image= [self diskImageForKey:key];
    if (image) {
        NSUInteger cost = JKCacheCostForImage(image);
        [self.memCache setObject:image forKey:key cost:cost];
    }
    return image;
    
}


- (UIImage *)diskImageForKey:(NSString *)key
{
    NSData *data =[self diskImageDataBySearchingAllPathsForKey:key];
    if (data) {
        UIImage *image = [UIImage jk_imageWithData:data];
       
        return image;
    }
    
    return nil;
}

- (NSData *)diskImageDataBySearchingAllPathsForKey:(NSString *)key
{
    NSString * fileNamePath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:fileNamePath];
    if (data) {
        return data;
    }
    return nil;
}


- (void)removeFileIntPath:(NSString *)filaPath
{
    [self.fileManager removeItemAtPath:filaPath error:NULL];
}



- (void)cleanDiskFile{
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        

        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-JKCacheMaxAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;

        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        

        
        if (jKMxCacheSize > 0 && currentCacheSize > jKMxCacheSize) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = jKMxCacheSize / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if ([_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }

    
            
    }];
    [self.queueCache addOperation:operation];
 
}


@end
