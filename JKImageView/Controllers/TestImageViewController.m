//
//  TestImageViewController.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestImageViewController.h"
#import "UIImageView+JKWebCache.h"



@interface TestImageViewController ()

@property (nonatomic, strong) UIImageView *testImageView;

@end

@implementation TestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg
//    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg"]]];
    
    // Do any additional setup after loading the view.
    _testImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, JKdeviceWidth, JKdeviceHeight)];
    _testImageView.contentMode = UIViewContentModeScaleAspectFit;
    _testImageView.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.183];
    [self.view addSubview:_testImageView];
    
//    [_testImageView jk_setImageWithURL:[NSURL URLWithString:@"http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif"]];
    [_testImageView jk_setImageWithURL:[NSURL URLWithString:@"http://whosv-images.b0.upaiyun.com/image/image/e594bc73667c001fa3e11a9e44f14d06.JPEG!140x140p"]];
//    [_testImageView sd_setImageWithURL:[NSURL URLWithString:@"http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif"]];

//    _testImageView.image = image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
