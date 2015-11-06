//
//  TestImageViewController.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestImageViewController.h"

@interface TestImageViewController ()

@property (nonatomic, strong) UIImageView *testImageView;

@end

@implementation TestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _testImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, JKdeviceWidth, JKdeviceHeight)];
    _testImageView.contentMode = UIViewContentModeScaleAspectFit;
    _testImageView.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.183];
    [self.view addSubview:_testImageView];

    //http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg
    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg"]]];
    _testImageView.image = image;
    
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
