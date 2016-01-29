//
//  XYUserRegisterViewController.m
//  网络教育平台
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYUserRegisterViewController.h"
#import "XYUserinfo.h"
#import "XYXMPPTool.h"
#import "AFNetworking.h"
#import "NSString+md5.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD+KR.h"

@interface XYUserRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userRegiserNameField;
@property (weak, nonatomic) IBOutlet UITextField *userRegiserPasswdField;
@property (weak, nonatomic) IBOutlet UITextField *userRegisterNickNameField;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCode;

@end

@implementation XYUserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getIdentifyingCode:(id)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.userRegiserNameField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证码获取成功");
        } else {
            NSLog(@"错误%@",error);
        }
    }];
}


- (IBAction)registerBtn:(id)sender {
    [SMSSDK commitVerificationCode:self.identifyingCode.text phoneNumber:self.userRegiserNameField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证成功");
            [XYUserinfo sharedXYUserinfo].registerType = YES;
            [XYUserinfo sharedXYUserinfo].userRegisterNickName = self.userRegisterNickNameField.text;
            [XYUserinfo sharedXYUserinfo].userRegisterName = self.userRegiserNameField.text;
            [XYUserinfo sharedXYUserinfo].userRegisterPasswd = self.userRegiserPasswdField.text;
            __weak typeof (self) vc = self;
            [[XYXMPPTool sharedXYXMPPTool] userRegister:^(XYXMPPResultType type) {
                [vc handleRegisterType:type];
            }];
        } else {
            NSLog(@"验证失败");
            [MBProgressHUD showError:@"验证失败"];
            return ;
        }
    }];

}

- (void) handleRegisterType:(XYXMPPResultType) type {
    switch (type) {
        case XYXMPPResultTypeRegisterSuccess:
            MYLog(@"注册成功");
            [self webRegister];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case XYXMPPResultTypeRegisterFaild:
            MYLog(@"注册失败");
            break;
        case XYXMPPResultTypeNetError:
            MYLog(@"网络错误");
            break;
        default:
            break;
    }
}

- (void) webRegister {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://%@:8080/allRunServer/register.jsp",XYXMPPHOSTNAME];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = [XYUserinfo sharedXYUserinfo].userRegisterName;
    parameters[@"md5password"] = [[XYUserinfo sharedXYUserinfo].userRegisterPasswd md5StrXor];
    parameters[@"nickname"] = [XYUserinfo sharedXYUserinfo].userRegisterNickName;
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *headImage = [UIImage imageNamed:@"header"];
        NSData *data = UIImagePNGRepresentation(headImage);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"headImage.png" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MYLog(@"111%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MYLog(@"222%@",error);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}




















@end
