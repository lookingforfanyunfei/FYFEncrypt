//
//  FYFHexHelper.h
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  16进制处理字符串
 */

@interface FYFHexHelper : NSObject

/**
 *  普通字符串转成16进制字符串
 *
 *  @param string 字符串
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 *  数据转成16进制字符串
 *
 *  @param data 数据
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromData:(NSData *)data;


/**
 *  char字符串转成16进制字符串
 *
 *  @param bytes 数据
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromChar:(char *)bytes;

/**
 *  普通字符串转成16进制数据
 *
 *  @param string 字符串
 *
 *  @return 16进制数据
 */
+(NSData *)hexDataFromString:(NSString *)string;

/**
 *  数据转成16进制数据
 *
 *  @param data 数据
 *
 *  @return 16进制数据
 */
+ (NSData *)hexDataFromData:(NSData *)data;

/**
 *  16进制字符串转成普通字符串
 *
 *  @param hexString 16进制字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/**
 *  16进制数据转成普通字符串
 *
 *  @param data 16进制数据
 *
 *  @return 普通字符串
 */
+ (NSString *)stringFromHexData:(NSData *)data;

/**
 *  16进制字符串转成普通数据
 *
 *  @param data 16进制字符串
 *
 *  @return 普通数据
 */
+ (NSData *)dataFromHexString:(NSString *)hexString;

/**
 *  16进制数据转成普通数据
 *
 *  @param data 16进制数据
 *
 *  @return 普通数据
 */
+ (NSData *)dataFromHexData:(NSData *)data;

/**
 *  @Author fanyunfei, 2015-07-14 13:07:43
 *
 *  16进制字符串转换成字符数组
 *
 *  @param hexString 16进制字符串
 *
 *  @return 字符数组
 */
+ (char *)charFromHexString:(NSString *)hexString;

/**
 *  10进制数字转成16进制的字符串
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromInteger:(NSInteger)value;

/**
 *  10进制数字字符串转成16进制的字符串
 *
 *  @return 16进制字符串
 */
+(NSString *)hexStringFromIntegerString:(NSString *)integerStr;

/**
 *  16进制字符串转成10进制数字
 *
 *  @return 10进制数字
 */
+(NSInteger)integerFromHexString:(NSString *)hexString;

/**
 *  16进制字符串转成10进制数字字符串
 *
 *  @return 10进制数字字符串
 */
+(NSString *)integerStringFromHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
