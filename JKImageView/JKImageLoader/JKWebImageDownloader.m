//
//  JKWebImageDownloader.m
//  JKImageView
//
//  Created by Jack on 15/11/18.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "JKWebImageDownloader.h"
#import "UIImage+JKMultiFormat.h"
@interface JKWebImageDownloader ()<NSURLSessionDownloadDelegate>

@property (nonatomic , copy)JKWebImageCompletBlock completedBlock;
@property (nonatomic , copy)JKWebImageDownloaderProgressBlock progressBlock;
@property (nonatomic, strong) NSURL *url;
@property (strong, nonatomic) NSURLSessionDownloadTask *cancellableTask; // 可取消的下载任务
@property (nonatomic, strong) NSURLSession * currentSession;
@property (strong, atomic) NSThread *thread;
@property (nonatomic, strong) NSMutableData * imageData;
@property (nonatomic, strong) NSURLRequest *request;

@end


@implementation JKWebImageDownloader



- (instancetype)initWithURL:(NSURL *)url
                   progress:(JKWebImageDownloaderProgressBlock )progressBlock
                  completed:(JKWebImageCompletBlock)completedBlock;
{
    
    if (self == [super init]) {
        self.completedBlock = [completedBlock copy];
        self.progressBlock = [progressBlock copy];
        self.url = url;
        self.request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        self.opration = [NSBlockOperation blockOperationWithBlock:^{
            [self startDownload];
        }];
    
    }
    
    return self;
}
/* 创建当前的session */
- (void)createCurrentSession {
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.currentSession = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:nil];
    self.currentSession.sessionDescription = self.url.absoluteString;
}

- (void)startDownload
{
    [self createCurrentSession];
    self.cancellableTask = [self.currentSession downloadTaskWithRequest:self.request];
    [self.cancellableTask resume];

}

#pragma markNSURLSessionDownLoadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    NSLog(@"%lld %lld %lld",bytesWritten ,totalBytesExpectedToWrite,totalBytesWritten);
    self.progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    // 1.将下载成功后的文件移动到目标路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    
    if ([fileManager fileExistsAtPath:[destinationPath path] isDirectory:NULL]) {
        [fileManager removeItemAtURL:destinationPath error:NULL];
    }
    
    NSError *error = nil;
    if ([fileManager moveItemAtURL:location toURL:destinationPath error:&error]) {
        // 2.刷新视图，显示下载后的图片
        NSData *data = [NSData dataWithContentsOfFile:[destinationPath path]];
        UIImage *image = [UIImage jk_imageWithData:data];
        self.completedBlock(image , error,self.request.URL,data);
    }
    self.cancellableTask = nil;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //    location	NSURL *	@"file:///Users/Jack/Library/Developer/CoreSimulator/Devices/4E450358-BB57-4B31-9C73-F8423DB60243/data/Containers/Data/Application/25F1DE2D-628A-40F5-AEA8-0751BB03B580/tmp/CFNetworkDownload_Sx9v0P.tmp"	0x00007fa19a2005b0
    
    if (error) {
        self.completedBlock(nil,error,self.request.URL,nil);
    }
    
}


@end
