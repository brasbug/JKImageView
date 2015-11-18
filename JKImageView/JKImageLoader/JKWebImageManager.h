//
//  JKWebImageManager.h
//  JKImageView
//
//  Created by Jack on 15/11/18.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKImageMarco.h"


@interface JKWebImageManager : NSObject


+ (instancetype)sharedManager;

- (void)downloadImageWithURL:(NSURL *)url
                    progress:(JKWebImageDownloaderProgressBlock )progressBlock
                   completed:(JKWebImageCompletBlock)completedBlock;

@end
