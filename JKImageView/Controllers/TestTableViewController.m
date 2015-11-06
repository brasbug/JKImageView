//
//  TestTableViewController.m
//  JKImageView
//
//  Created by Jack on 15/11/6.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "TestTableViewController.h"
#import "TestTableViewCell.h"

@interface TestTableViewController ()


@property (nonatomic, assign) NSInteger listCount;

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listCount = 0;
    
    UIButton *loadDatabtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loadDatabtn.frame = CGRectMake(0, 0, 60, 44);
    [loadDatabtn setTitle:@"加载数据" forState:UIControlStateNormal];
    //    [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loadDatabtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [loadDatabtn addTarget: self action: @selector(loadDatabtnPressed) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *loadDataButtonItem =[[UIBarButtonItem alloc]initWithCustomView:loadDatabtn];
    self.navigationItem.rightBarButtonItem = loadDataButtonItem;
    
}

-(void)loadDatabtnPressed
{
    _listCount = 20;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TestTableViewCell" owner:self options:nil].firstObject;
    }
    //@"http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg":@"http://imgsrc.baidu.com/forum/w%3D580/sign=bbe8c06043166d223877159c76220945/599e9d3df8dcd10054b2bf8a728b4710b8122fcc.jpg
    NSInteger type = 0;
    if (indexPath.row%2) {
        [cell setContentImageUrl:(type)?@"http://b.zol-img.com.cn/desk/bizhi/image/4/1920x1200/1384480949246.jpg":@"http://imgsrc.baidu.com/forum/w%3D580/sign=bbe8c06043166d223877159c76220945/599e9d3df8dcd10054b2bf8a728b4710b8122fcc.jpg"];
    }
    else
    {
        [cell setContentImageUrl:(type)?@"http://b.hiphotos.baidu.com/zhidao/pic/item/b3fb43166d224f4ae984285b0bf790529822d15d.jpg":@"http://imgsrc.baidu.com/forum/w%3D580/sign=af6a303cd933c895a67e9873e1127397/53f4c9ef76094b360ce15c46a3cc7cd98c109d87.jpg"];
    }
    return cell;
}




@end
