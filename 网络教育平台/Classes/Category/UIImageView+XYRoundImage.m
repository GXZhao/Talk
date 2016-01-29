//
//  UIImageView+XYRoundImage.m
//  网络教育平台
//
//  Created by tarena on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "UIImageView+XYRoundImage.h"

@implementation UIImageView (XYRoundImage)
-(void)setRoundLater {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width*0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor whiteColor]CGColor];
}
@end
