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
#import "JKWebImageDownloader.h"
#import "JKWebImageManager.h"

#import "UIImageView+JKWebCache.h"
#import "AFNetworking.h"


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



- (IBAction)JKTestBtnPressed:(id)sender
{
    [self.testImageView jk_setImageWithURL:[NSURL URLWithString:@"http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif"]];
//    [self.testImageView jk_setImageWithURL:[NSURL URLWithString:@"http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif"] PlaceHolder:nil progress:^(NSInteger receiveSize, NSInteger expecteSize) {
//        
//    } completed:^(UIImage *image, NSError *error, NSURL *imageURL,NSData *dataOrigin) {
//        
//    }];
    
//    [[JKWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:@"http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif"] progress:^(NSInteger receiveSize, NSInteger expecteSize) {
//        
//    } completed:^(UIImage *image, NSError *error, NSURL *imageURL) {
//        
//    }];
    
    //http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif
    //http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg
//    [[[JKWebImageDownloader alloc]initWithURL:[NSURL URLWithString:@"http://s1.dwstatic.com/group1/M00/18/23/1244a21b95f70cb20db2489fe69fb3bb.gif"] progress:^(NSInteger receiveSize, NSInteger expecteSize) {
//        
//    } completed:^(UIImage *image, NSError *error, NSURL *imageURL) {
//    
//    }] startDownload];
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


- (IBAction)uploadTest:(id)sender {

    
//    NSString *service = [NSString stringWithFormat:@"%@post%@",path,[params description]];
//
//    
//    
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
// 
//    
//    NSError *err;
//    
//    NSMutableURLRequest * request = [serializer multipartFormRequestWithMethod:@"POST" URLString:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i<imagesData.count; i++)
//        {
//            NSData *imageData =[imagesData objectAtIndex:i];
//            NSString *tempFileName = [NSString stringWithFormat:@"photo%d.JPEG",i];
//            NSInteger count = i;
//            if (count >= imageKeys.count) {
//                
//                count = imageKeys.count-1;
//            }
//            NSString *imageName = [imageKeys objectAtIndex:count];
//            
//            if ([imageData length]>0)
//            {
//                [formData appendPartWithFileData:imageData name:imageName fileName:tempFileName mimeType:@"image/jpeg"];
//            }
//        }
//        
//        
//    } error:&err];
//    
//    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestOperation *operation =
//    [manager HTTPRequestOperationWithRequest:request
//                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                         [self removeServiceName:service];
//                                         successBlock(responseObject);
//                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"%@ %@",operation,error);
//                                         [self removeServiceName:service];
//                                         
//                                         if (error.userInfo) {
//                                             if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
//                                                 NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
//                                                 [dic setValue:[error.userInfo objectForKey:@"NSLocalizedDescription"] forKey:@"message"];
//                                                 [dic setValue:@"10000502" forKey:@"code"];
//                                                 
//                                                 failureBlock(dic);
//                                             }else
//                                             {
//                                                 failureBlock(@{@"message":CustomLocalizedString(@"checkNetworking", @""),@"code":@"99999"});
//                                             }
//                                         }
//                                         else
//                                         {
//                                             //TODO
//                                             failureBlock(@{@"message":@"未定义错误",@"code":@"A001"});
//                                         }
//                                     }];
//    
//    // 4. Set the progress block of the operation.
//    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
//                                        long long totalBytesWritten,
//                                        long long totalBytesExpectedToWrite) {
//        //                NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
//        progresBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//        
//    }];
//    
//    // 5. Begin!
//    [operation start];
    
    
    
    
    
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
