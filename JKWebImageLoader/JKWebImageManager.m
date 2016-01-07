
//
//  JKWebImageManager.m
//  JKImageView
//
//  Created by Jack on 15/11/18.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "JKWebImageManager.h"
#import "JKImageCache.h"
#import "JKWebImageDownloader.h"


@interface JKWebImageManager ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (strong, nonatomic, readwrite) JKImageCache *imageCache;
@property (nonatomic, strong) NSMutableArray *urlArr;

@property (nonatomic, strong) NSMutableArray * operationCacheArr;

@property (nonatomic, strong) NSMutableDictionary * downloaderCacheDic;
@end



@implementation JKWebImageManager

- (instancetype)init {
    if ((self = [super init])) {
        self.imageCache = [JKImageCache shareInstance];
        self.queue = [[NSOperationQueue alloc]init];
        self.downloaderCacheDic = [NSMutableDictionary dictionary];
        self.operationCacheArr = [NSMutableArray array];
    }
    return self;
}


+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)cancellALL
{
    for (JKWebImageDownloader *downloder in self.operationCacheArr) {
        [downloder cancelDownload];
        [downloder.opration cancel];
    }
}

- (void)cancellWithURL:(NSURL *)url
{
    if ([self.downloaderCacheDic objectForKey:url.absoluteString]) {
        JKWebImageDownloader *downloder = [self.downloaderCacheDic objectForKey:url.absoluteString];
        [downloder cancelDownload];
        [downloder.opration cancel];
    }
}

- (void)downloadImageWithURL:(NSURL *)url
                    progress:(JKWebImageDownloaderProgressBlock )progressBlock
                   completed:(JKWebImageCompletBlock)completedBlock
{
    UIImage *image =  [[JKImageCache shareInstance] imageFromDiskCacheForKey:url.absoluteString];
    if (image) {
        completedBlock(image,nil,url,nil);  
    }
    else
    {
        __weak __typeof(self)wself = self;

       __block JKWebImageDownloader *downloder =[[JKWebImageDownloader alloc]initWithURL:url progress:^(NSInteger receiveSize, NSInteger expecteSize) {
            if (progressBlock) {
                progressBlock(receiveSize,expecteSize);
            }
        } completed:^(UIImage *image, NSError *error, NSURL *imageURL, NSData *dataOrigin) {
            
            [[JKImageCache shareInstance]storeImage:image imageData:dataOrigin forKey:imageURL.absoluteString toDisk:YES];
            if (completedBlock) {
                completedBlock(image,error,imageURL,dataOrigin);
            }
            [wself.downloaderCacheDic removeObjectForKey:imageURL.absoluteString];
            if ([self.operationCacheArr containsObject:downloder]) {
                [self.operationCacheArr removeObject:downloder];
            }
        }];
        [self.queue addOperation:downloder.opration];
        [self.operationCacheArr addObject:downloder];
        [self.downloaderCacheDic setObject:downloder forKey:url.absoluteString];
    }
}





@end
