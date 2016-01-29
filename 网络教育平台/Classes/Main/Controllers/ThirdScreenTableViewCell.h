//
//  ThirdScreenTableViewCell.h
//  网络教学平台
//
//  Created by tarena on 15/12/30.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTestTopic.h"

@protocol XYTestCellProtocol <NSObject>

- (void)addConcatp:(NSString *) jidStr;

@end

@interface ThirdScreenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guanZhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myTopicView;
@property (nonatomic, strong) id<XYTestCellProtocol> delegate;

- (void) setDataWithTopic:(XYTestTopic *) topic;

@end
