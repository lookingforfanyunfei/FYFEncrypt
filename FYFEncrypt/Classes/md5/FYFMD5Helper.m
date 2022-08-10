//
//  FYFMD5Helper.m
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/8/19.
//

#import "FYFMD5Helper.h"
#import <CommonCrypto/CommonDigest.h>
#import <FYFCategory/NSObject+FYFExtension.h>

/**
 *  MD5帮组类
 */
@implementation FYFMD5Helper

/**
 *  MD5摘要算法
 *
 *  @param str 要编码的字符串
 *
 *  @return 编码后的字符串
 */
+ (NSString *)md5Encrypt:(NSString *)string {
    if (!fyf_empty(string)) {
        return [self md5EncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return @"";
}

/**
 *
 *  MD5摘要算法
 *
 *  @param data 要编码的二进制
 *
 *  @return 编码后的字符串
 */
+ (NSString *)md5EncryptData:(NSData *)data {
    if (data && data.length > 0) {
        return [self md5EncryptBytes:(char *)[data bytes] length:(uint32_t)data.length];
    }
    return @"";
}

/**
 *
 *  MD5摘要算法
 *
 *  @param bytes   要编码的二进制
 *  @param length 要编码的二进制长度
 *
 *  @return 编码后的字符串
 */
+ (NSString *)md5EncryptBytes:(char *)bytes length:(uint32_t)length {
    const char *original_str = bytes;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, length, result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

@end
