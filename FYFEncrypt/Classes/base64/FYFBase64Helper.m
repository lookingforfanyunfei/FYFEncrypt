//
//  FYFBase64Helper.m
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import "FYFBase64Helper.h"
#import <FYFEncrypt/FYFGTMBase64.h>
#import <FYFCategory/NSObject+FYFExtension.h>

@implementation FYFBase64Helper

/**
 *  base64加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)stringWithEncodeBase64String:(NSString *)string {
    if (!fyf_empty(string)) {
        NSData *data = [FYFBase64Helper dataWithEncodeBase64String:string];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (NSString*)stringWithWebSafeEncodeBase64String:(NSString *)string {
    if (!fyf_empty(string)) {
         NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
         data = [FYFGTMBase64 webSafeEncodeData:data padded:NO];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  base64解密
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密后的字符串
 */
+ (NSString*)stringWithDecodeBase64String:(NSString *)string {
    if (!fyf_empty(string)) {
        NSData *data = [FYFBase64Helper dataWithDecodeBase64String:string];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (NSString*)stringWithWebSafeDecodeBase64String:(NSString *)string {
    if (!fyf_empty(string)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        data = [FYFGTMBase64 webSafeDecodeData:data];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  base64加密
 *
 *  @param data 需要加密的数据
 *
 *  @return 加密后的字符串
 */
+ (NSString*)stringWithEncodeBase64Data:(NSData *)data {
    if (data && data.length > 0) {
        NSData *newData = [FYFBase64Helper dataWithEncodeBase64Data:data];
        return [[NSString alloc]initWithData:newData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  base64解密
 *
 *  @param data 需要解密的数据
 *
 *  @return 解密后后的字符串
 */
+ (NSString*)stringWithDecodeBase64Data:(NSData *)data {
    if (data && data.length > 0) {
        NSData *newData = [FYFBase64Helper dataWithDecodeBase64Data:data];
        return [[NSString alloc]initWithData:newData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  base64加密
 *
 *  @param data 需要加密的数据
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithEncodeBase64Data:(NSData *)data {
    if (data && data.length > 0) {
        return [FYFGTMBase64 encodeData:data];
    }
    return [NSData data];
}

/**
 *  base64加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithEncodeBase64String:(NSString *)string {
    if (!fyf_empty(string)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return [FYFBase64Helper dataWithEncodeBase64Data:data];
    }
    return [NSData data];
}

/**
 *  base64解密
 *
 *  @param data 需要解密的数据
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDecodeBase64Data:(NSData *)data {
    if (data && data.length > 0) {
        return [FYFGTMBase64 decodeData:data];
    }
    return [NSData data];
}

/**
 *  base64解密
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDecodeBase64String:(NSString *)string {
    if (!fyf_empty(string)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return [FYFBase64Helper dataWithDecodeBase64Data:data];
    }
    return [NSData data];
}

@end
