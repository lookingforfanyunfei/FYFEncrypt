//
//  FYFMD5Helper.h
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/8/19.
//

#import <Foundation/Foundation.h>

/**
 *  MD5帮组类
 */

NS_ASSUME_NONNULL_BEGIN

@interface FYFMD5Helper : NSObject

/**
 *  MD5摘要算法
 *
 *  @param str 要编码的字符串
 *
 *  @return 编码后的字符串
 */
+ (NSString *)md5Encrypt:(NSString *)str;

/**
 *
 *  MD5摘要算法
 *
 *  @param data 要编码的二进制
 *
 *  @return 编码后的字符串
 */
+ (NSString *)md5EncryptData:(NSData *)data;

/**
 *
 *  MD5摘要算法
 *
 *  @param data   要编码的二进制
 *  @param length 要编码的二进制长度
 *
 *  @return 编码后的字符串
 */
+ (NSString *)md5EncryptBytes:(char *)bytes length:(uint32_t)length;

@end

NS_ASSUME_NONNULL_END
