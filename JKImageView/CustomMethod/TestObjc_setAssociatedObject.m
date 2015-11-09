//
//  TestObjc_setAssociatedObject.m
//  JKImageView
//
//  Created by Jack on 15/11/9.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestObjc_setAssociatedObject.h"
#import "objc/runtime.h"

static char overviewKey;

@implementation TestObjc_setAssociatedObject

- (void)testAssociatedObject
{
    
    //为了演示的目的，这里使用initWithFormat:来确保字符串可以被销毁
    NSURL *url = [NSURL URLWithString:@"asdfasd"];
    objc_setAssociatedObject(self, &overviewKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
    id obj = objc_getAssociatedObject(self, &overviewKey);
    NSLog(@"%@ == %@",obj,[obj class]);
    
    
}

@end
