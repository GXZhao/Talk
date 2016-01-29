//
//  XYAddFriendViewController.m
//  网络教育平台
//
//  Created by tarena on 16/1/27.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYAddFriendViewController.h"
#import "XMPPJID.h"
#import "XYXMPPTool.h"
#import "MBProgressHUD+KR.h"
#import "XYUserinfo.h"

@interface XYAddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *friendID;

@end

@implementation XYAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)sureBtn:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self addConcatp:self.friendID.text];

    });

}

//增加好友逻辑
- (void) addConcatp:(NSString *) jidName {
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",jidName,XYXMPPDOMAIN];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    if ([[XYXMPPTool sharedXYXMPPTool].xmppRoserStore userExistsWithJID:jid xmppStream:[XYXMPPTool sharedXYXMPPTool].xmppStream]) {
//        [MBProgressHUD showError:@"对方已经是你的好友"];
        return;
    }
    if ([jidStr isEqualToString:[XYUserinfo sharedXYUserinfo].jidStr]) {
//        [MBProgressHUD showError:@"不能添加自己"];
        return;
    }
    [[XYXMPPTool sharedXYXMPPTool].xmppRoser subscribePresenceToUser:jid];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"添加成功"];
        sleep(5);
        [MBProgressHUD hideHUD];

    });
    
}

- (IBAction)notSureBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
