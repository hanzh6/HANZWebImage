//
//  NSString+MD5.m
//  HZWBDemo
//
//  Created by 韩政 on 2019/8/16.
//  Copyright © 2019 韩政. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString(MD5)

+ (NSString *)getMD5:(NSString *)md5Str{
    const char *str = md5Str.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    return [strM copy];
}

@end
