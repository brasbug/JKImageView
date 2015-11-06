//
//  ViewController.m
//  JKImageView
//
//  Created by Jack on 15/11/5.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "TestSyncThread.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UIButton *syncThreadBtn;

@property (nonatomic, strong)  TestSyncThread *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    _testImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, JKdeviceWidth, JKdeviceHeight)];
//    _testImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _testImageView.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.183];
//    [self.view addSubview:_testImageView];
    
    //http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg
   
    
    
}



- (IBAction)syncThreadBtnPressed:(id)sender {
    self.test = [[TestSyncThread alloc]init];
    [self.test startSyncThreadTest];
    
}



- (IBAction)syncCancelThreadOneBtnPressed:(id)sender
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
