//
//  LoginViewController.m
//  网络教学平台
//
//  Created by tarena on 15/12/30.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LoginViewController.h"
#import "XYUserinfo.h"
#import "XYXMPPTool.h"
#import "MBProgressHUD+KR.h"
#import "XYUserRegisterViewController.h"
#import "XYForgetPasswordViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (weak, nonatomic) IBOutlet UITextField *userPassedField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (IBAction)userBtnClick:(id)sender {
    if (self.userNameField.text.length == 0 || self.userPassedField.text.length == 0) {
        [MBProgressHUD showError:@"用户名和密码不能为空"];
        return ;
    }
    [XYUserinfo sharedXYUserinfo].registerType = NO;
    XYUserinfo *userInfo = [XYUserinfo sharedXYUserinfo];
    userInfo.userName = self.userNameField.text;
    userInfo.userPasswd = self.userPassedField.text;
    [MBProgressHUD showMessage:@"正在登录..."];
    __weak typeof (self)vc = self;
    [[XYXMPPTool sharedXYXMPPTool] userLogin:^(XYXMPPResultType type) {
        [MBProgressHUD hideHUD];
        [vc handleLoginResultType:type];
    }];
}

- (void) handleLoginResultType:(XYXMPPResultType) type {
    switch (type) {
        case XYXMPPResultTypeLoginSucess: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            break;
        }
        case XYXMPPResultTypeLoginFaild:
            [MBProgressHUD showError:@"用户名或密码错误"];
            break;
        case XYXMPPResultTypeNetError:
            [MBProgressHUD showError:@"网络错误"];
            break;
        default:
            break;
    }
}

- (void)dealloc {
    MYLog(@"登录控制器销毁:%@",self);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}










@end
