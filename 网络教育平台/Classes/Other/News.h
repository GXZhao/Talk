//
//  News.h
//  Demo4_新闻客户端
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property(nonatomic,strong)NSString *newsImageName;
@property(nonatomic,strong)NSString *title;
@property(nonatomic)NSInteger commentNumber;
+(NSArray *)demoData;

@end
