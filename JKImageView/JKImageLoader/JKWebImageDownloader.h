//
//  JKWebImageDownloader.h
//  JKImageView
//
//  Created by Jack on 15/11/18.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKWebImageDownloader : NSObject

@property (nonatomic, strong) NSBlockOperation *opration;

- (instancetype)initWithURL:(NSURL *)url
                   progress:(JKWebImageDownloaderProgressBlock )progressBlock
                  completed:(JKWebImageCompletBlock)completedBlock;


- (void)startDownload;

@end
