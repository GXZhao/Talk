//
//  XYXMPPTool.h
//  网络教育平台
//
//  Created by tarena on 16/1/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "Singleton.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

typedef enum {
    XYXMPPResultTypeLoginSucess,
    XYXMPPResultTypeLoginFaild,
    XYXMPPResultTypeNetError,
    XYXMPPResultTypeRegisterSuccess,
    XYXMPPResultTypeRegisterFaild
}XYXMPPResultType;

typedef void(^XYResultBlock)(XYXMPPResultType type);

@interface XYXMPPTool : NSObject

singleton_interface(XYXMPPTool)
@property (nonatomic, strong) XMPPStream *xmppStream;
//增加个人电子名片模块 和 头像模块
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCard;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvar;
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStore;
//增加好友列表模块,和对应的存储
@property (nonatomic, strong) XMPPRoster *xmppRoser;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRoserStore;
//增加消息模块
@property (nonatomic, strong) XMPPMessageArchiving *xmppMsgArch;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMsgArchStore;
//自动重连模块
@property (nonatomic, strong) XMPPReconnect *xmppReconn;
/** 初始化XMPP流 */
- (void) setXmpp;
/** 连接服务器 */
- (void) connectHost;
/** 发送密码 */
- (void) sendPasswdToHost;
/** 发送在线消息 */
- (void) sendOnLine;
/** 发送离线消息 */
- (void) sendOffLine;
#pragma mark 用户登录
/** 用户登录 */
- (void) userLogin:(XYResultBlock) block;
/** 用户注册 */
- (void) userRegister:(XYResultBlock) block;
/** 清理资源 */
- (void) cleanResource;






@end
