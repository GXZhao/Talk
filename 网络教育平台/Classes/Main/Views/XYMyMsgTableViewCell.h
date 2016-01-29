//
//  XYMyMsgTableViewCell.h
//  网络教育平台
//
//  Created by tarena on 16/1/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYMyMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageMsgView;
@property (weak, nonatomic) IBOutlet UILabel *textMsgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end
