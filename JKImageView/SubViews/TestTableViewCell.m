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
    [self.imageViewk jk_setImage_ThreadWithURL:[NSURL URLWithString:urlStr]];
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
