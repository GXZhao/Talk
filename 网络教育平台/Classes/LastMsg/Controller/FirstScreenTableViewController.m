//
//  FirstScreenTableViewController.m
//  网络教学平台
//
//  Created by tarena on 15/12/29.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "FirstScreenTableViewController.h"
#import "XYXMPPTool.h"
#import "XYUserinfo.h"
#import "UIImageView+XYRoundImage.h"
#import "XYChatViewController.h"
#import "UIImageView+XYRoundImage.h"
#import "XMPPMessageArchiving.h"
#import "XYMessageCell.h"

@interface FirstScreenTableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSArray  *friends;
@property (nonatomic,strong) NSArray  *friendNames;
@property (nonatomic,strong) NSArray  *mostMsgs;


@property (nonatomic, strong) NSFetchedResultsController *fechControl;
@end

@implementation FirstScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadFriends];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLastMsg];

    [self.tableView reloadData];
}

- (void) loadLastMsg {
    NSManagedObjectContext *context = [[XYXMPPTool sharedXYXMPPTool].xmppMsgArchStore mainThreadManagedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",[XYUserinfo sharedXYUserinfo].jidStr];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:YES];
    request.predicate = pre;
    request.sortDescriptors = @[sortDes];
    NSError *error = nil;
//    self.fechControl = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//    self.fechControl.delegate = self;
//    [self.fechControl performFetch:&error];
    self.mostMsgs = [context executeFetchRequest:request error:&error];
    if (error) {
        MYLog(@"%@",error);
    }

}
- (void) loadFriends {
    // 获得上下文
    NSManagedObjectContext *context = [[XYXMPPTool sharedXYXMPPTool].xmppMsgArchStore mainThreadManagedObjectContext];
    // 请求对象关联实体
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 过滤条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",
                        [XYUserinfo sharedXYUserinfo].jidStr];
    requst.predicate = pre;
    // order by
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    requst.sortDescriptors = @[sort];
    self.friends = [context executeFetchRequest:requst error:nil];
    NSMutableSet * names = [NSMutableSet set];
    for (int i=0; i<self.friends.count; i++) {
        XMPPMessageArchiving_Message_CoreDataObject *ma = self.friends[i];
        [names addObject:ma.bareJidStr];
    }
    self.friendNames = [names allObjects];
}

//查找最后的信息
- (XMPPMessageArchiving_Message_CoreDataObject *) findLastMessage:(NSString *) bareJidStr {
    for (int i=0; i<self.friends.count; i++) {
        XMPPMessageArchiving_Message_CoreDataObject *ma = self.friends[i];
        if ([ma.bareJidStr isEqualToString:bareJidStr]) {
            return ma;
        }
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView2:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.mostMsgs.count;
//    return self.fechControl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    XMPPMessageArchiving_Contact_CoreDataObject *ma = self.mostMsgs[indexPath.row];
    cell.nikeNameLabel.text = ma.bareJidStr;

    /* 根据信息显示头像 */
    NSData * imagedata = [[XYXMPPTool sharedXYXMPPTool].xmppvCardAvar photoDataForJID:[XMPPJID jidWithString:ma.bareJidStr]];
    [cell.friendHeadImage  setRoundLater];
    if(imagedata !=nil){
        cell.friendHeadImage.image = [UIImage imageWithData:imagedata];
    }else{
        cell.friendHeadImage.image = [UIImage imageNamed:@"微信"];
    }
    if ([ma.mostRecentMessageBody hasPrefix:@"image"]) {
        cell.lastMessageLabel.text = @"图片";
    }else{
        NSString  *base64Str = [ma.mostRecentMessageBody substringFromIndex:4];
        NSData *base64data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
        cell.lastMessageLabel.text = [[NSString alloc]initWithData:base64data encoding:NSUTF8StringEncoding];
    }
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    cell.lastMessageDateLabel.text = [format stringFromDate:ma.mostRecentMessageTimestamp];

//    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    XMPPMessageArchiving_Contact_CoreDataObject *obj = self.fechControl.fetchedObjects[indexPath.row];
//    if ([obj.mostRecentMessageBody hasPrefix:@"image:"]) {
//        cell.textLabel.text = @"[图片]";
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.textColor = [UIColor grayColor];
//    } else if ([obj.mostRecentMessageBody hasPrefix:@"text:"]) {
//        cell.textLabel.text = [obj.mostRecentMessageBody substringFromIndex:5];
//    }
//    NSData *imageData = [[XYXMPPTool sharedXYXMPPTool].xmppvCardAvar photoDataForJID:[XMPPJID jidWithString:obj.bareJidStr]];
//    []

    return cell;

}

- (UITableViewCell*) tableView2:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    XMPPMessageArchiving_Message_CoreDataObject *ma =
    [self findLastMessage:self.friendNames[indexPath.row]];
    cell.nikeNameLabel.text = ma.bareJidStr;
    /* 根据信息显示头像 */
    [cell.friendHeadImage  setRoundLater];
    NSData * imagedata = [[XYXMPPTool sharedXYXMPPTool].xmppvCardAvar photoDataForJID:[XMPPJID jidWithString:ma.bareJidStr]];
    if(imagedata !=nil){
        cell.friendHeadImage.image = [UIImage imageWithData:imagedata];
    }else{
        cell.friendHeadImage.image = [UIImage imageNamed:@"微信"];
    }
    if ([ma.message.body hasPrefix:@"image"]) {
        cell.lastMessageLabel.text = @"图片";
    }else{
        NSString  *base64Str = [ma.message.body substringFromIndex:4];
        NSData *base64data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
        cell.lastMessageLabel.text = [[NSString alloc]initWithData:base64data encoding:NSUTF8StringEncoding];
    }
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    cell.lastMessageDateLabel.text = [format stringFromDate:ma.timestamp];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    XMPPMessageArchiving_Contact_CoreDataObject *ma = self.mostMsgs[indexPath.row];
    [self performSegueWithIdentifier:@"chatSegue2" sender:ma.bareJid];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id vc = segue.destinationViewController;
    if ([vc isKindOfClass:[XYChatViewController class]]) {
        XYChatViewController *chatVc = (XYChatViewController *)vc;
        chatVc.friendJid = sender;

    }
}


@end
