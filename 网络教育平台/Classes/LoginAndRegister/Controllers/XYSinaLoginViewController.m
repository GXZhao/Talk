//
//  XYSinaLoginViewController.m
//  网络教育平台
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYSinaLoginViewController.h"
#define  APPKEY       @"2075708624"
#define  REDIRECT_URI @"http://www.tedu.cn"
#define  APPSECRET    @"36a3d3dec55af644cd94a316fdd8bfd8"
#import "AFNetworking.h"
#import "XYXMPPTool.h"
#import "XYUserInfo.h"
#import "MBProgressHUD+KR.h"
#import "NSString+md5.h"

@interface XYSinaLoginViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XYSinaLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",APPKEY,REDIRECT_URI];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlPath = request.URL.absoluteString;
    NSRange range = [urlPath rangeOfString:[NSString stringWithFormat:@"%@/?code=",REDIRECT_URI]];
    NSString *code = nil;
    if (range.length > 0) {
        code = [urlPath substringFromIndex:range.length];
        MYLog(@"code:%@",code);
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

- (void) accessTokenWithCode:(NSString *) code {
    NSString *url = @"https://api.weibo.com/oauth2/access_token";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"client_id"] = APPKEY;
    dictionary[@"client_secret"] = APPSECRET;
    dictionary[@"grant_type"] = @"authorization_code";
    dictionary[@"code"] = code;
    dictionary[@"redirect_uri"] = REDIRECT_URI;
    [manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MYLog(@"获取token成功");
        MYLog(@"%@",responseObject);
        [XYUserinfo sharedXYUserinfo].userRegisterName = responseObject[@"uid"];
        [XYUserinfo sharedXYUserinfo].userRegisterPasswd = responseObject[@"access_token"];
        [XYUserinfo sharedXYUserinfo].registerType = YES;
        __weak typeof (self) vc = self;
        [[XYXMPPTool sharedXYXMPPTool] userRegister:^(XYXMPPResultType type) {
            [vc handleRegisterResultType:type];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MYLog(@"获取token失败");
    }];
}

- (void) handleRegisterResultType:(XYXMPPResultType) type {
    switch (type) {
        case XYXMPPResultTypeRegisterSuccess:{
            MYLog(@"注册成功");
            [self webRegister];
        }
        case XYXMPPResultTypeRegisterFaild:{
            MYLog(@"注册失败");
            [XYUserinfo sharedXYUserinfo].userName = [XYUserinfo sharedXYUserinfo].userRegisterName;
            [XYUserinfo sharedXYUserinfo].userPasswd = [XYUserinfo sharedXYUserinfo].userRegisterPasswd;
            [XYUserinfo sharedXYUserinfo].registerType = NO;
            [[XYXMPPTool sharedXYXMPPTool] userLogin:^(XYXMPPResultType type) {
                [self handleLoginResultType:type];
            }];
        }
            break;
        case XYXMPPResultTypeNetError:{
            MYLog(@"网络错误");
        }
            break;
        default:
            break;
    }
}

- (void) handleLoginResultType:(XYXMPPResultType) type {
    switch (type) {
        case XYXMPPResultTypeLoginSucess:{
            MYLog(@"登录失败");
            [self dismissViewControllerAnimated:YES completion:nil];
            UIStoryboard *stroyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = stroyborad.instantiateInitialViewController;
        }
            break;
        case XYXMPPResultTypeLoginFaild:{

        }
            break;
        case XYXMPPResultTypeNetError:{

        }
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
