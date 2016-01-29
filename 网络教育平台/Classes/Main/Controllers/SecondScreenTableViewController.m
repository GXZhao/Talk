//
//  SecondScreenTableViewController.m
//  网络教学平台
//
//  Created by tarena on 15/12/29.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SecondScreenTableViewController.h"
#import "XYXMPPTool.h"
#import "XYUserinfo.h"
#import "XYFriendCell.h"
#import "UIImageView+XYRoundImage.h"
#import "XYChatViewController.h"


@interface SecondScreenTableViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchController;

@end

@implementation SecondScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFriend];
}

- (void) loadFriend {
    NSManagedObjectContext *context = [[XYXMPPTool sharedXYXMPPTool].xmppRoserStore mainThreadManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",[XYUserinfo sharedXYUserinfo].jidStr];
    request.predicate = pre;
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sortDes];
    NSError *error = nil;
    self.fetchController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchController.delegate = self;
    [self.fetchController performFetch:&error];
    if (error) {
        MYLog(@"%@",error);
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"friendCell";
    XYFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifer];
    XMPPUserCoreDataStorageObject *friend = self.fetchController.fetchedObjects[indexPath.row];
    NSData *data = [[XYXMPPTool sharedXYXMPPTool].xmppvCardAvar photoDataForJID:friend.jid];
    if (data) {
        cell.headImageView.image = [UIImage imageWithData:data];
    }else {
        cell.headImageView.image = [UIImage imageNamed:@"微博"];
    }
    [cell.headImageView setRoundLater];
    cell.userNameLabel.text = friend.jidStr;
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.friendStatuLabel.text = @"在线";
            cell.friendStatuLabel.textColor = [UIColor greenColor];
            break;
        case 1:
            cell.friendStatuLabel.text = @"离开";
            cell.friendStatuLabel.textColor = [UIColor redColor];
            break;
        case 2:
            cell.friendStatuLabel.text = @"离线";
            break;
        default:
            break;
    }
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPUserCoreDataStorageObject *friend = self.fetchController.fetchedObjects[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[XYXMPPTool sharedXYXMPPTool].xmppRoser removeUser:friend.jid];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id desVc = segue.destinationViewController;
    if ([desVc isKindOfClass:[XYChatViewController class]]) {
        XYChatViewController *des = (XYChatViewController *) desVc;
        des.friendJid = sender;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPUserCoreDataStorageObject *f = self.fetchController.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"chatSegue" sender:f.jid];
}


@end
