//
//  ThirdScreenTableViewController.m
//  网络教学平台
//
//  Created by tarena on 15/12/29.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "ThirdScreenTableViewController.h"
#import "ThirdScreenTableViewCell.h"
#import "UIImageView+XYRoundImage.h"
#import "AFNetworking.h"
#import "XYUserinfo.h"
#import "XYTestTopic.h"
#import "UIImageView+WebCache.h"
#import "XMPPJID.h"
#import "XYXMPPTool.h"
#import "MBProgressHUD+KR.h"

@interface ThirdScreenTableViewController ()<XYTestCellProtocol>

@property (nonatomic, strong) NSMutableArray *topicArray;

@end

@implementation ThirdScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125.0;
    self.topicArray = [NSMutableArray array];
//    [MBProgressHUD showMessage:@"数据加载 请稍后..."];
    [self loadData];

}

- (void) loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://%@:8080/allRunServerNew/queryTopic.jsp",XYXMPPHOSTNAME];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"username"] = [XYUserinfo sharedXYUserinfo].userName;
    dict[@"md5password"] = [XYUserinfo sharedXYUserinfo].userPasswd;
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideHUD];
        NSArray *dataArray = responseObject[@"data"];
        for (int i = 0; i < dataArray.count; i++) {
            XYTestTopic *topic = [[XYTestTopic alloc]init];
            [topic setValuesForKeysWithDictionary:dataArray[i]];
            [self.topicArray addObject:topic];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@"数据加载失败"];
//        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThirdScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mytopiccell"];
    cell.delegate = self;
    cell.headImageView.image = [UIImage imageNamed:@"微信"];
    [cell.headImageView setRoundLater];
    [cell setDataWithTopic:self.topicArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}





@end
