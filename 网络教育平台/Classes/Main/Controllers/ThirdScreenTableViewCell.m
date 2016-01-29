//
//  ThirdScreenTableViewCell.m
//  网络教学平台
//
//  Created by tarena on 15/12/30.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "ThirdScreenTableViewCell.h"
#import "XYXMPPTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@implementation ThirdScreenTableViewCell

- (void)setDataWithTopic:(XYTestTopic *)topic {
    self.topicLabel.text = topic.content;
    if (topic.imageUrl) {
        NSString *imageurl = [NSString stringWithFormat:@"http://%@:8080/%@",XYXMPPHOSTNAME,topic.imageUrl];
        [self.myTopicView setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"背景"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
    }
    self.topicLabel.text = topic.content;
    self.nikeNameLabel.text = topic.username;
}

@end
