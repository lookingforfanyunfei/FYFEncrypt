//
//  FYFBase64Helper.h
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 *  Base64帮组类
 */

@interface FYFBase64Helper : NSObject


/**
 *  base64加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)stringWithEncodeBase64String:(NSString *)string;
+ (NSString*)stringWithWebSafeEncodeBase64String:(NSString *)string;

/**
 *  base64解密
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密后的字符串
 */
+ (NSString*)stringWithDecodeBase64String:(NSString *)string;
+ (NSString*)stringWithWebSafeDecodeBase64String:(NSString *)string;

/**
 *  base64加密
 *
 *  @param data 需要加密的数据
 *
 *  @return 加密后的字符串
 */
+ (NSString*)stringWithEncodeBase64Data:(NSData *)data;

/**
 *  base64解密
 *
 *  @param data 需要解密的数据
 *
 *  @return 解密后后的字符串
 */
+ (NSString*)stringWithDecodeBase64Data:(NSData *)data;

/**
 *  base64加密
 *
 *  @param data 需要加密的数据
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithEncodeBase64Data:(NSData *)data;

/**
 *  base64加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithEncodeBase64String:(NSString *)string;

/**
 *  base64解密
 *
 *  @param data 需要解密的数据
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDecodeBase64Data:(NSData *)data;

/**
 *  base64解密
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDecodeBase64String:(NSString *)string;


@end

NS_ASSUME_NONNULL_END
