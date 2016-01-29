//
//  XYUserinfo.h
//  网络教育平台
//
//  Created by tarena on 16/1/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface XYUserinfo : NSObject

singleton_interface(XYUserinfo)
@property (nonatomic, assign, getter=isRegisterType) BOOL registerType;
/* 用户的姓名和密码 */
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPasswd;
// 用户注册信息
@property (nonatomic, copy) NSString *userRegisterName;
@property (nonatomic, copy) NSString *userRegisterPasswd;
@property (nonatomic, copy) NSString *userRegisterNickName;
@property (nonatomic, strong) NSString *jidStr;
/* 是否是新浪登录  */
@property (nonatomic,assign) BOOL sinaLogin;
@property (nonatomic,copy)  NSString *sinaToken;
/* 用户数据的沙盒读写 */
- (void) saveXYUserInfoToSandBox;
- (void) loadXYUserInfoFromSandBox;
@end
