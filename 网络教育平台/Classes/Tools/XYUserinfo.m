//
//  XYUserinfo.m
//  网络教育平台
//
//  Created by tarena on 16/1/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYUserinfo.h"

@implementation XYUserinfo

singleton_implementation(XYUserinfo)
//用户数据的沙盒读写
- (void)saveXYUserInfoToSandBox {
    [[NSUserDefaults standardUserDefaults] setValue:self.userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userPasswd forKey:@"userPwd"];
}

- (void)loadXYUserInfoFromSandBox {
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.userPasswd = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
}

- (NSString *)jidStr {
    return [NSString stringWithFormat:@"%@@%@",self.userName,XYXMPPDOMAIN];
}
@end
