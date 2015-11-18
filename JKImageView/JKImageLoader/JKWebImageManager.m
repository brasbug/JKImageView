
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
@end



@implementation JKWebImageManager

- (instancetype)init {
    if ((self = [super init])) {
        self.imageCache = [JKImageCache shareInstance];
        self.queue = [[NSOperationQueue alloc]init];

        
        
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
        [self.queue addOperation:[[JKWebImageDownloader alloc]initWithURL:url progress:^(NSInteger receiveSize, NSInteger expecteSize) {
            if (progressBlock) {
                progressBlock(receiveSize,expecteSize);
            }
        } completed:^(UIImage *image, NSError *error, NSURL *imageURL, NSData *dataOrigin) {
            
            [[JKImageCache shareInstance]storeImage:image imageData:dataOrigin forKey:url.absoluteString toDisk:YES];
            if (completedBlock) {
                completedBlock(image,error,imageURL,dataOrigin);
            }
        }].opration];
    }
}





@end
