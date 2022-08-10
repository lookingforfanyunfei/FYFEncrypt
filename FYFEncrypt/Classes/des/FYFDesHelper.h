//
//  FYFDesHelper.h
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYFDesHelper : NSObject


/**
 *  Des加密,先加密，再做base64编码
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *)stringWithDesEncryptString:(NSString *)string withKey:(NSString *)key;

/**
 *  Des加密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithDesEncryptString:(NSString *)string withKey:(NSString *)key;

/**
 *  Des加密
 *
 *  @param data 数据
 *  @param key    秘钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithDesEncryptData:(NSData *)data withKey:(NSString *)key;

/**
 *  Des解密，先base64解码，再解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 解密后的字符串
 */
+ (NSString *)stringWithDesDecryptString:(NSString *)string withKey:(NSString *)key;

/**
 *  Des解密，先base64解码，再解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDesDecryptString:(NSString *)string withKey:(NSString *)key;

/**
 *  Des解密
 *
 *  @param data 数据
 *  @param key    秘钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDesDecryptData:(NSData *)data withKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
