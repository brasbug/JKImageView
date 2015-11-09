//
//  ViewController.m
//  JKImageView
//
//  Created by Jack on 15/11/5.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "TestSyncThread.h"
#import "TestGCDMethod.h"
#import "TestOperation.h"
#import "TestObjc_setAssociatedObject.h"



@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *testImageView;
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



- (IBAction)testNSOperationBtnPressed:(id)sender {
    TestOperation *test =[[TestOperation alloc]init];
//    [test testInvocationOperation];
    [test starAsyncThread_Use_NSOperationqueueWith:self.testImageView];
//    [test startAsyncThread_Use_NSBlockOperationWith:self.testImageView];
//    [test testThreadDependencyThread];
//    [test cancelSomeThread];
    
}


- (IBAction)syncThreadBtnPressed:(id)sender {
    self.test = [[TestSyncThread alloc]init];
//    [self.test startSyncThreadTest];
    [self.test starThreadWith:self.testImageView];
}



- (IBAction)testGCDBtnPressed:(id)sender
{
    TestGCDMethod *test = [[TestGCDMethod alloc]init];
//    [test testConcurrentDisQueue];
//    [test testSerialDisQueue];
    [test testSyncQueue];
}


- (IBAction)nomalTestBtnPressed:(id)sender {
    
    TestObjc_setAssociatedObject *test = [[TestObjc_setAssociatedObject alloc]init];
    [test testAssociatedObject];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
