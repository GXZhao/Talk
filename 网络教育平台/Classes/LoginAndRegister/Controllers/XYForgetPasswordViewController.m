//
//  XYForgetPasswordViewController.m
//  网络教育平台
//
//  Created by tarena on 16/1/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYForgetPasswordViewController.h"
#import "XYUserinfo.h"
#import "XYXMPPTool.h"
#import "AFNetworking.h"
#import "NSString+md5.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD+KR.h"

@interface XYForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCode;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;

@end

@implementation XYForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)getIdentifyingCode:(id)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNum.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证码获取成功");
        } else {
            NSLog(@"错误%@",error);
        }
    }];

}

- (IBAction)changeBtn:(id)sender {
    if ([self.password2.text isEqualToString:self.password1.text]) {
        [SMSSDK commitVerificationCode:self.identifyingCode.text phoneNumber:self.phoneNum.text zone:@"86" result:^(NSError *error) {
            if (!error) {

            } else {
                NSLog(@"验证失败");
                [MBProgressHUD showError:@"验证失败"];
                return ;
            }
        }];
    } else {
        [MBProgressHUD showError:@"密码输入不一致"];
    }

}

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
