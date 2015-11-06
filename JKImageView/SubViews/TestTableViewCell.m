//
//  TestTableViewCell.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell


- (void)setContentImageUrl:(NSString *)urlStr
{
    //开启线程
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downLoadImage:) object:urlStr];
    [thread start];
    
//    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
//    self.imageViewk.image = image;
//    [self.imageViewk sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}


- (void)downLoadImage:(NSString *)url
{
    //在子线程中完成下载
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image == nil){
        //这里可以写下载失败方法
    }else{
        //这里写成功回调， 回调到主线程   这个就是所谓的线程间通讯，
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
        //除了可以更新主线程的数据外，还可以更新其他线程的比如：用:performSelector:onThread:withObject:waitUntilDone:
    }
}

-(void)updateUI:(UIImage*) image{
    self.imageViewk.image = image;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.imageViewk.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
