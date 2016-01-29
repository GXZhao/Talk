//
//  XYChatViewController.h
//  网络教育平台
//
//  Created by tarena on 16/1/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
#import "XMPPvCardTemp.h"

@interface XYChatViewController : UIViewController
@property (nonatomic, strong) XMPPJID *friendJid;
@property (nonatomic, strong) XMPPvCardTemp *myProfile;
@end
