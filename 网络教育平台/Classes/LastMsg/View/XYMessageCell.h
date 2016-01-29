//
//  XYMessageCell.h
//  网络教育平台
//
//  Created by tarena on 16/1/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageDateLabel;

@end
