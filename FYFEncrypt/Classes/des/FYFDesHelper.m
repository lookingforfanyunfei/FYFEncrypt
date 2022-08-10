//
//  FYFDesHelper.m
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import "FYFDesHelper.h"

#import <CommonCrypto/CommonCryptor.h>
#import <FYFCategory/NSObject+FYFExtension.h>
#import <FYFEncrypt/FYFBase64Helper.h>

@implementation FYFDesHelper

/**
 *  Des加密，先加密，再做base64编码
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *)stringWithDesEncryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFDesHelper dataWithDesEncryptString:string withKey:key];
        return [FYFBase64Helper stringWithEncodeBase64Data:data];
    }
    return @"";
}

/**
 *  Des加密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithDesEncryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return [FYFDesHelper dataWithDesEncryptData:data withKey:key];
    }
    return [NSData data];
}

/**
 *  Des加密
 *
 *  @param data 数据
 *  @param key    秘钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithDesEncryptData:(NSData *)data withKey:(NSString *)key {
    if (data && data.length > 0 && !fyf_empty(key)) {
        char keyPtr[kCCKeySizeAES256 + 1];
        bzero(keyPtr, sizeof(keyPtr));
        
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        
        NSUInteger dataLength = [data length];
        
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              keyPtr, kCCBlockSizeDES,
                                              NULL,
                                              [data bytes], dataLength,
                                              buffer, bufferSize,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        }
        
        free(buffer);
        return [NSData data];
    }
    return [NSData data];
}

/**
 *  Des解密，先base64解码，再解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 解密后的字符串
 */
+ (NSString *)stringWithDesDecryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFDesHelper dataWithDesDecryptString:string withKey:key];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  Des解密，先base64解码，再解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDesDecryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFBase64Helper dataWithDecodeBase64String:string];
        return [FYFDesHelper dataWithDesDecryptData:data withKey:key];
    }
    return [NSData data];
}

/**
 *  Des解密
 *
 *  @param data 数据
 *  @param key    秘钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithDesDecryptData:(NSData *)data withKey:(NSString *)key {
    if (data && data.length > 0 && !fyf_empty(key)) {
        char keyPtr[kCCKeySizeAES256 + 1];
        bzero(keyPtr, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [data length];
        size_t bufferSize = dataLength + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              keyPtr, kCCBlockSizeDES,
                                              NULL,
                                              [data bytes], dataLength,
                                              buffer, bufferSize,
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        }
        
        free(buffer);
        return [NSData data];
    }
    return [NSData data];
}


@end
