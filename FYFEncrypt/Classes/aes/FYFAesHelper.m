//
//  FYFAesHelper.m
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import "FYFAesHelper.h"
#import <CommonCrypto/CommonCryptor.h>
#import <FYFCategory/NSObject+FYFExtension.h>
#import <FYFEncrypt/FYFBase64Helper.h>

@implementation FYFAesHelper


/**
 *  Aes加密ECB模式，先做AES加密，再做Base64编码
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *)stringWithAesEncryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFAesHelper dataWithAesEncryptString:string withKey:key];
        return [FYFBase64Helper stringWithEncodeBase64Data:data];
    }
    return @"";
}

/**
 * Aes加密ECB模式
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithAesEncryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return [FYFAesHelper dataWithAesEncryptData:data withKey:key];
    }
    return [NSData data];
}

/**
 *   Aes加密ECB模式
 *
 *  @param data 数据
 *  @param key    秘钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithAesEncryptData:(NSData *)data withKey:(NSString *)key {
    return [self dataWithAesEncryptData:data withKey:key mode:AesMode_ECB];
}

/**
 *  Aes解密ECB模式，先做base64解码，再做aes解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 解密后的字符串
 */
+ (NSString *)stringWithAesDecryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFAesHelper dataWithAesDecryptString:string withKey:key];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  Aes解密ECB模式，先做base64解码，再做aes解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithAesDecryptString:(NSString *)string withKey:(NSString *)key {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFBase64Helper dataWithDecodeBase64String:string];
        return [FYFAesHelper dataWithAesDecryptData:data withKey:key];
    }
    return [NSData data];
}

/**
 *  Aes解密ECB模式
 *
 *  @param data 数据
 *  @param key    秘钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithAesDecryptData:(NSData *)data withKey:(NSString *)key {
    return [self dataWithAesDecryptData:data withKey:key mode:AesMode_ECB];
}

/**
 *  Aes加密模式，先做AES加密，再做Base64编码
 *
 *  @param string 字符串
 *  @param key    秘钥
 *  @param mode   模式
 *
 *  @return 加密后的字符串
 */
+ (NSString *)stringWithAesEncryptString:(NSString *)string withKey:(NSString *)key mode:(AesMode)mode {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFAesHelper dataWithAesEncryptString:string withKey:key mode:mode];
        return [FYFBase64Helper stringWithEncodeBase64Data:data];
    }
    return @"";
}

/**
 *  Aes加密模式
 *
 *  @param string 字符串
 *  @param key    秘钥
 *  @param mode   模式
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithAesEncryptString:(NSString *)string withKey:(NSString *)key mode:(AesMode)mode {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return [FYFAesHelper dataWithAesEncryptData:data withKey:key mode:mode];
    }
    return [NSData data];
}

/**
 *  Aes加密模式
 *
 *  @param data   数据
 *  @param key    秘钥
 *  @param mode   模式
 *
 *  @return 加密后的数据
 */
+ (NSData *)dataWithAesEncryptData:(NSData *)data withKey:(NSString *)key mode:(AesMode)mode {
    if (data && data.length > 0 && !fyf_empty(key)) {
        int blockSize = (key.length > 16) ? kCCKeySizeAES256 : kCCKeySizeAES128;
        char keyPtr[blockSize + 1];
        bzero(keyPtr, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [data length];
        size_t bufferSize = (dataLength + blockSize);
        void *buffer = malloc(bufferSize);
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = kCCSuccess;
        if (mode == AesMode_ECB) {
            cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                    kCCOptionECBMode | kCCOptionPKCS7Padding,
                    keyPtr, blockSize,
                    NULL,
                    [data bytes], dataLength,
                    buffer, bufferSize,
                    &numBytesEncrypted);
        } else if (mode == AesMode_ECB_NOPADDING) {
            cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                  kCCOptionECBMode,
                                  keyPtr, blockSize,
                                  NULL,
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesEncrypted);
        } else if (mode == AesMode_CBC) {
            cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                  kCCOptionPKCS7Padding,
                                  keyPtr, blockSize,
                                  [[key dataUsingEncoding:NSUTF8StringEncoding]bytes],
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesEncrypted);
        } else if (mode == AesMode_CBC_NOPADDING) {
            cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                  0x0000,
                                  keyPtr, blockSize,
                                  [[key dataUsingEncoding:NSUTF8StringEncoding]bytes],
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesEncrypted);
        }
        if (cryptStatus == kCCSuccess) {
            return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        }
        free(buffer);
        return [NSData data];
    }
    return [NSData data];
}

/**
 *  Aes解密，先做base64解码，再做aes解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *  @param mode   模式
 *
 *  @return 解密后的字符串
 */
+ (NSString *)stringWithAesDecryptString:(NSString *)string withKey:(NSString *)key mode:(AesMode)mode {
    if (!fyf_empty(string) && !fyf_empty(key)) {
        NSData *data = [FYFAesHelper dataWithAesDecryptString:string withKey:key mode:mode];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/**
 *  Aes解密，先做base64解码，再做aes解密
 *
 *  @param string 字符串
 *  @param key    秘钥
 *  @param mode   模式
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithAesDecryptString:(NSString *)string withKey:(NSString *)key mode:(AesMode)mode {
    if (!fyf_empty(string) && !fyf_empty(string)) {
        NSData *data = [FYFBase64Helper dataWithDecodeBase64String:string];
        return [FYFAesHelper dataWithAesDecryptData:data withKey:key mode:mode];
    }
    return [NSData data];

}

/**
 *  Aes解密
 *
 *  @param data   数据
 *  @param key    秘钥
 *  @param mode   模式
 *
 *  @return 解密后的数据
 */
+ (NSData *)dataWithAesDecryptData:(NSData *)data withKey:(NSString *)key mode:(AesMode)mode {
    if (data && data.length > 0 && !fyf_empty(key)) {
        int blockSize = (key.length > 16) ? kCCKeySizeAES256 : kCCKeySizeAES128;
        char keyPtr[blockSize + 1];
        bzero(keyPtr, sizeof(keyPtr));
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [data length];
        size_t bufferSize = dataLength + blockSize;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = kCCSuccess;
        if (mode == AesMode_ECB) {
            cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                  kCCOptionECBMode | kCCOptionPKCS7Padding,
                                  keyPtr, blockSize,
                                  NULL,
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesDecrypted);
        } else if (mode == AesMode_ECB_NOPADDING) {
            cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                  kCCOptionECBMode,
                                  keyPtr, blockSize,
                                  NULL,
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesDecrypted);
        } else if (mode == AesMode_CBC) {
            cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                  kCCOptionPKCS7Padding,
                                  keyPtr, blockSize,
                                  [[key dataUsingEncoding:NSUTF8StringEncoding]bytes],
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesDecrypted);
        } else if (mode == AesMode_CBC_NOPADDING) {
            cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                  0x0000,
                                  keyPtr, blockSize,
                                  [[key dataUsingEncoding:NSUTF8StringEncoding]bytes],
                                  [data bytes], dataLength,
                                  buffer, bufferSize,
                                  &numBytesDecrypted);
        }
        if (cryptStatus == kCCSuccess) {
            return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        }
        free(buffer);
        return [NSData data];
    }
    return [NSData data];
}


@end
