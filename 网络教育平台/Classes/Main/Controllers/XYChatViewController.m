//
//  XYChatViewController.m
//  网络教育平台
//
//  Created by tarena on 16/1/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYChatViewController.h"
#import "XYUserinfo.h"
#import "XYXMPPTool.h"
#import "UIImageView+XYRoundImage.h"
#import "XYMyMsgTableViewCell.h"
#import "XYOtherMsgCell.h"
#import "Masonry.h"

@interface XYChatViewController ()<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
////@property (weak, nonatomic) IBOutlet UITextView *sendTextField;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForBottom;
////@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
//@property (weak, nonatomic) IBOutlet UITextView *sendTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForBottom;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (nonatomic, strong) NSFetchedResultsController *fechControl;
@property (nonatomic, strong) UIImage *meImage;
@property (nonatomic, strong) UIImage * friendImage;
@end


@implementation XYChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendTextField.text = @"";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
//    NSLog(@"%@",self.fechControl.fetchedObjects);
    [self loadMsg];
    NSData *data = self.myProfile.photo;
    if (data == nil) {
        self.meImage = [UIImage imageNamed:@"微信"];
    } else {
        self.meImage = [UIImage imageWithData:data];
    }
    NSData *fdata = [[XYXMPPTool sharedXYXMPPTool].xmppvCardAvar photoDataForJID:self.friendJid];
    if (fdata == nil) {
        self.friendImage = [UIImage imageNamed:@"微信"];
    } else {
        self.friendImage = [UIImage imageWithData:fdata];
    }

}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.sendTextField resignFirstResponder];
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.sendTextField resignFirstResponder];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyBorad:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBorad:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollTable];
}

- (void) loadMsg {
    NSManagedObjectContext *context = [[XYXMPPTool sharedXYXMPPTool].xmppMsgArchStore mainThreadManagedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@ and bareJidStr=%@",[XYUserinfo sharedXYUserinfo].jidStr,[self.friendJid bare]];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.predicate = pre;
    request.sortDescriptors = @[sortDes];
    self.fechControl = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    self.fechControl.delegate = self;
    [self.fechControl performFetch:&error];
    if (error) {
        MYLog(@"数据请求失败");
    }
}

- (void) openKeyBorad:(NSNotification *) notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSTimeInterval durations = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions optiuons = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    self.heightForBottom.constant = keyboardFrame.size.height;
    [UIImageView animateWithDuration:durations delay:0 options:optiuons animations:^{
        [self.view layoutIfNeeded];
        [self scrollTable];
    } completion:^(BOOL finished) {

    }];

}

- (void) closeKeyBorad:(NSNotification *) notification {
    //    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSTimeInterval durations = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions optiuons = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    self.heightForBottom.constant = 0;
    [UIImageView animateWithDuration:durations delay:0 options:optiuons animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fechControl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *message = self.fechControl.fetchedObjects[indexPath.row];
    if ([message.body hasPrefix:@"text"]) {
        if (message.isOutgoing) {
            XYMyMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMsgCell"];
            //设置label背景
            cell.backImage.image = [UIImage imageNamed:@"背景"];
            [cell.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.headImageView.mas_right).mas_equalTo(16);
                make.top.mas_equalTo(cell.userNameLabel.mas_bottom).mas_equalTo(6);
                make.size.mas_equalTo(CGSizeMake(cell.textMsgLabel.bounds.size.width + 8,cell.textMsgLabel.bounds.size.height + 8));
            }];
            [cell.backImage addSubview:cell.textMsgLabel];
//            UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
//            [cell.textMsgLabel setBackgroundColor:color];

            cell.headImageView.image = self.meImage;
            [cell.headImageView setRoundLater];
            NSString *base64Str = [message.body substringFromIndex:4];
            NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.imageMsgView.image = nil;
            cell.textMsgLabel.text = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
            cell.userNameLabel.text = [XYUserinfo sharedXYUserinfo].userName;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.msgTimeLabel.text = [formater stringFromDate:message.timestamp];
            return cell;
        } else {
            XYOtherMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherTextCell"];
            //设置label背景
//            UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
//            [cell.chatTextLabel setBackgroundColor:color];

            cell.headImageView.image = self.friendImage;
            [cell.headImageView setRoundLater];
            cell.popImageView.image = nil;
            NSString *base64Str = [message.body substringFromIndex:4];
            NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.chatTextLabel.text = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
            cell.nickName.text = self.friendJid.user;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.timeLabel.text = [formater stringFromDate:message.timestamp];
            return cell;
        }
    }
    if ([message.body hasPrefix:@"image"]) {
        if (message.isOutgoing) {
            XYMyMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMsgCell"];
            cell.headImageView.image = self.meImage;
            [cell.headImageView setRoundLater];
            NSString *base64Str = [message.body substringFromIndex:5];
            NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.textMsgLabel.text = nil;
            cell.imageMsgView.image = [UIImage imageWithData:base64Data];
            cell.userNameLabel.text = [XYUserinfo sharedXYUserinfo].userName;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.msgTimeLabel.text = [formater stringFromDate: message.timestamp];
            return cell;
        } else {
            XYOtherMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherTextCell"];
            cell.headImageView.image = self.friendImage;
            [cell.headImageView setRoundLater];
            cell.detailTextLabel.text = @"";
            cell.popImageView.image = nil;
            NSString *base64Str = [message.body substringFromIndex:5];
            NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.popImageView.image = [UIImage imageWithData:base64Data];
            cell.nickName.text = self.friendJid.user;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.timeLabel.text = [formater stringFromDate: message.timestamp];
            return cell;
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}



//打开相册
- (IBAction)clickBtn:(UIButton *)sender {

    UIImagePickerController *pc = [[UIImagePickerController alloc]init];
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pc.delegate = self;
    [self presentViewController:pc animated:YES completion:nil];
}

//生成缩略图
- (UIImage *) thumbnaiWithImage:(UIImage *) image size:(CGSize) size {
    UIImage *newImage = nil;
    if (image == nil) {
        newImage = nil;
    }else {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

//选择图片
/* UIImagePickerController 代理方法 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *newImage = [self thumbnaiWithImage:image size:CGSizeMake(100, 100)];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.05);
    [self sendMessageWithData:data bodyName:@"image"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送文本消息
- (IBAction)sendBtnClick:(id)sender {
    NSString *msg = self.sendTextField.text;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self sendMessageWithData:data bodyName:@"text"];
}

//发送
- (void) sendMessageWithData:(NSData *) data bodyName:(NSString *)name{
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [msg addBody:[name stringByAppendingString:base64Str]];
    //发送消息
    [[XYXMPPTool sharedXYXMPPTool].xmppStream sendElement:msg];
    msg = nil;
    self.sendTextField.text = nil;

}
//刷新
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
    [self scrollTable];
}
//滚到最后一行
- (void) scrollTable {
    NSInteger index = self.fechControl.fetchedObjects.count - 1;
    if (index < 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
