//
//  NSString+md5.m
//  网络教育平台
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

- (NSString *)md5StrXor {
    const char *myPasswd = [self UTF8String];
    unsigned char mdc[16];
    CC_MD5(myPasswd, (CC_LONG)strlen(myPasswd), mdc);
    NSMutableString *md5String = [NSMutableString string];
    [md5String appendFormat:@"%02x",mdc[0]];
    for (int i = 1; i < 16; i ++) {
        [md5String appendFormat:@"%02x",mdc[i]^mdc[0]];
    }
    return [md5String copy];

}

@end
