//
//  News.m
//  Demo4_新闻客户端
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "News.h"

@implementation News

+(NSArray *)demoData
{
    News *n1 = [[News alloc]init];
    n1.newsImageName = @"n1.png";
    n1.title = @"这是一段比较长的文本，用于测试标题是否换行1";
    n1.commentNumber = 1234;

    News *n2 = [[News alloc]init];
    n2.newsImageName = @"n2.png";
    n2.title = @"这是一段比较长的文本，用于测试标题是否换行2";
    n2.commentNumber = 2345;

    News *n3 = [[News alloc]init];
    n3.newsImageName = @"n3.png";
    n3.title = @"这是一段比较长的文本，用于测试标题是否换行3";
    n3.commentNumber = 56;

    News *n4 = [[News alloc]init];
    n4.newsImageName = @"n4.png";
    n4.title = @"这是一段比较长的文本，用于测试标题是否换行4";
    n4.commentNumber = 567;

    News *n5 = [[News alloc]init];
    n5.newsImageName = @"n5.png";
    n5.title = @"这是一段比较长的文本，用于测试标题是否换行5";
    n5.commentNumber = 134;

    News *n6 = [[News alloc]init];
    n6.newsImageName = @"n6.png";
    n6.title = @"这是一段比较长的文本，用于测试标题是否换行6";
    n6.commentNumber = 134;

    News *n7 = [[News alloc]init];
    n7.newsImageName = @"n7.png";
    n7.title = @"这是一段比较长的文本，用于测试标题是否换行7";
    n7.commentNumber = 4563;

    News *n8 = [[News alloc]init];
    n8.newsImageName = @"n8.png";
    n8.title = @"这是一段比较长的文本，用于测试标题是否换行8";
    n8.commentNumber = 347567;

    return @[n1,n2,n3,n4,n5,n6,n7,n8];
}

@end
