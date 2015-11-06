//
//  TestTableViewCell.h
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewk;

- (void)setContentImageUrl:(NSString *)urlStr;

@end
