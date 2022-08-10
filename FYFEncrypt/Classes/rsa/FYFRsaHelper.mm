//
//  FYFRsaHelper.m
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import "FYFRsaHelper.h"

#import "FYFRSA.mm"
#import <FYFEncrypt/FYFHexHelper.h>
#import <FYFCategory/NSData+FYFExtension.h>
#import <FYFCategory/NSObject+FYFExtension.h>


@implementation FYFRsaHelper

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密，对应要用RSA私钥解密,加密后转成16进制字符串
 *
 *  @param content 需要加密的原始内容
 *  @param pubExpd 公钥指数
 *  @param module  公钥模数
 *  @param padding 加密格式
 *
 *  @return 加密后内容
 */
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pubExpd:(NSString *)pubExpd module:(NSString *)module padding:(int)padding {
    NSData *encryptedData = [self rsaPublicKeyEncryptData:[NSData fyf_dataWithString:content] pubExpd:pubExpd module:module padding:padding];
    return [FYFHexHelper hexStringFromData:encryptedData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密，对应要用RSA私钥解密
 *
 *  @param data    需要加密的原始二进制
 *  @param pubExpd 公钥指数
 *  @param module  公钥模数
 *  @param padding 加密格式
 *
 *  @return 加密后内容
 */
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pubExpd:(NSString *)pubExpd module:(NSString *)module padding:(int)padding {
    NSMutableString *temp = [NSMutableString stringWithString:pubExpd];
    while (temp.length < 6) {
        temp = [NSMutableString stringWithFormat:@"0%@",temp];
    }
    unsigned char *pubExpdChar = (unsigned char *)[FYFHexHelper charFromHexString:temp];
    unsigned char *moduleChar = (unsigned char *)[FYFHexHelper charFromHexString:module];
    
    int pubExpdSize = 3;
    int keySize = (int)(module.length / 2);
    
    FYFRSA rsa;
    rsa.set_params(pubExpdChar, pubExpdSize, NULL, keySize,moduleChar,keySize,padding);
    rsa.open_pubkey();
    
    int cipherBufferSize = keySize;
    uint8_t *cipherBuffer = (uint8_t *)malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i = 0; i < blockCount; i ++) {
        int bufferSize = (int)MIN(blockSize,[data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        // 下面两行是公钥加密，私钥解密
        int count = rsa.pubkey_encrypt((unsigned char *)[buffer bytes], (int)[buffer length], &cipherBuffer, cipherBufferSize);
        if (count > 0) {
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        } else {
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return [NSData data];
        }
    }
    if (cipherBuffer) {
        free(cipherBuffer);
    }
    rsa.close_key();
    return encryptedData;
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密，对应要用RSA私钥解密,加密后转成16进制字符串
 *
 *  @param content 需要加密的原始内容
 *  @param pubExpd 公钥指数
 *  @param module  公钥模数
 *
 *  @return 加密后内容
 */
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pubExpd:(NSString *)pubExpd module:(NSString *)module {
    return [self rsaPublicKeyEncryptString:content pubExpd:pubExpd module:module padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密，对应要用RSA私钥解密
 *
 *  @param data    需要加密的原始二进制
 *  @param pubExpd 公钥指数
 *  @param module  公钥模数
 *
 *  @return 加密后内容
 */
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pubExpd:(NSString *)pubExpd module:(NSString *)module {
    return [self rsaPublicKeyEncryptData:data pubExpd:pubExpd module:module padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密，先解码16进制，再解密
 *
 *  @param content  需要解密的密文内容
 *  @param pubExpd  公钥指数
 *  @param privExpd 私钥指数
 *  @param module   加密模数
 *  @param padding  加密格式
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module padding:(int)padding {
    NSData *decryptData = [self rsaPrivateKeyDecryptData:[FYFHexHelper dataFromHexString:content] pubExpd:pubExpd privExpd:privExpd module:module padding:padding];
    return [NSData fyf_stringWithData:decryptData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密
 *
 *  @param data     需要解密的密文二进制
 *  @param pubExpd  公钥指数
 *  @param privExpd 私钥指数
 *  @param module   加密模数
 *  @param padding  加密格式
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module padding:(int)padding {
    NSMutableString *temp = [NSMutableString stringWithString:pubExpd];
    while (temp.length < 6) {
        temp = [NSMutableString stringWithFormat:@"0%@",temp];
    }
    unsigned char *pubExpdChar = (unsigned char *)[FYFHexHelper charFromHexString:temp];
    unsigned char *privExpdChar = (unsigned char *)[FYFHexHelper charFromHexString:privExpd];
    unsigned char *moduleChar = (unsigned char *)[FYFHexHelper charFromHexString:module];
    
    int pubExpdSize = 3;
    int keySize = (int)(module.length / 2);
    
    FYFRSA rsa;
    rsa.set_params(pubExpdChar, pubExpdSize, privExpdChar, keySize,moduleChar,keySize,padding);
    rsa.open_prikey_pubkey();
    
    size_t blockSize = keySize;
    size_t blockNum = data.length / blockSize;
    NSMutableData *decryptedData = [[NSMutableData alloc] init];
    for(int i = 0; i < blockNum; i ++) {
        NSData *cipherData = [data subdataWithRange:NSMakeRange(i * blockSize, blockSize)];
        size_t cipherLen = [cipherData length];
        void *cipher = malloc(cipherLen);
        [cipherData getBytes:cipher length:cipherLen];
        int plainLen = (int)(blockSize - 11);
        void *plain = malloc(plainLen);
        // 下面两行是公钥加密，私钥解密
        int count = rsa.prikey_decrypt((unsigned char *)cipher, (int)cipherLen, (unsigned char **)&plain, plainLen);
        if (count <= 0) {
            return nil;
        }
        NSData *decryptedBytes = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
        [decryptedData appendData:decryptedBytes];
    }
    rsa.close_key();
    return decryptedData;
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密，先解码16进制，再解密
 *
 *  @param content  需要解密的密文内容
 *  @param pubExpd  公钥指数
 *  @param privExpd 私钥指数
 *  @param module   加密模数
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module {
    return [self rsaPrivateKeyDecryptString:content pubExpd:pubExpd privExpd:privExpd module:module padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密
 *
 *  @param data     需要解密的密文二进制
 *  @param pubExpd  公钥指数
 *  @param privExpd 私钥指数
 *  @param module   加密模数
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module {
    return [self rsaPrivateKeyDecryptData:data pubExpd:pubExpd privExpd:privExpd module:module padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(PEM证书格式)，对应要用RSA私钥解密，加密后转成16进制字符串
 *
 *  @param content     需要加密的原始内容
 *  @param pemFilePath pem公钥证书的路径，绝对路径
 *  @param padding     加密格式
 *
 *  @return 加密后内容
 */
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath padding:(int)padding {
    NSData *encryptData = [self rsaPublicKeyEncryptData:[NSData fyf_dataWithString:content] pemFilePath:pemFilePath padding:padding];
    return [FYFHexHelper hexStringFromData:encryptData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(PEM证书格式)，对应要用RSA私钥解密
 *
 *  @param data        需要加密的原始二进制
 *  @param pemFilePath pem公钥证书的路径，绝对路径
 *  @param padding     加密格式
 *
 *  @return 加密后内容
 */
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath padding:(int)padding {
    FYFRSA rsa;
    rsa.open_pubkey_pemfile((char *)[NSData fyf_charsWithString:pemFilePath ], padding);
    
    int cipherBufferSize = rsa.getBlockSize();
    uint8_t *cipherBuffer = (uint8_t *)malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i = 0; i < blockCount; i ++) {
        int bufferSize = (int)MIN(blockSize,[data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        // 下面两行是公钥加密，私钥解密
        int count = rsa.pubkey_encrypt((unsigned char *)[buffer bytes], (int)[buffer length], &cipherBuffer, cipherBufferSize);
        if (count > 0) {
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        } else {
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return [NSData data];
        }
    }
    if (cipherBuffer) {
        free(cipherBuffer);
    }
    rsa.close_key();
    return encryptedData;
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(PEM证书格式)，对应要用RSA私钥解密，加密后转成16进制字符串
 *
 *  @param content     需要加密的原始内容
 *  @param pemFilePath pem公钥证书的路径，绝对路径
 *
 *  @return 加密后内容
 */
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath {
    return [self rsaPublicKeyEncryptString:content pemFilePath:pemFilePath padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(PEM证书格式)，对应要用RSA私钥解密
 *
 *  @param data        需要加密的原始二进制
 *  @param pemFilePath pem公钥证书的路径，绝对路径
 *
 *  @return 加密后内容
 */
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath {
    return [self rsaPublicKeyEncryptData:data pemFilePath:pemFilePath padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(PEM证书格式)，先解码16进制，再解密
 *
 *  @param content     需要解密的密文内容
 *  @param pemFilePath pem私钥证书的路径，绝对路径
 *  @param password    pem私钥证书密码
 *  @param padding     加密格式
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath password:(NSString *)password padding:(int)padding {
    NSData *decryptData = [self rsaPrivateKeyDecryptData:[FYFHexHelper dataFromHexString:content] pemFilePath:pemFilePath password:password padding:padding];
    return [NSData fyf_stringWithData:decryptData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(PEM证书格式)
 *
 *  @param data        需要解密的密文二进制
 *  @param pemFilePath pem私钥证书的路径，绝对路径
 *  @param password    pem私钥证书密码
 *  @param padding     加密格式
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath password:(NSString *)password  padding:(int)padding {
    FYFRSA rsa;
    if (!fyf_empty(password)) {
        rsa.open_prikey_pemfile((char *)[NSData fyf_charsWithString:pemFilePath],(char *)[NSData fyf_charsWithString:password], padding);
    } else {
        rsa.open_prikey_pemfile((char *)[NSData fyf_charsWithString:pemFilePath], NULL,padding);
    }
    size_t blockSize = rsa.getBlockSize();
    if (blockSize <= 0) {
        return nil;
    }
    size_t blockNum = data.length / blockSize;
    NSMutableData *decryptedData = [[NSMutableData alloc] init];
    for(int i = 0; i < blockNum; i ++) {
        NSData *cipherData = [data subdataWithRange:NSMakeRange(i * blockSize, blockSize)];
        size_t cipherLen = [cipherData length];
        void *cipher = malloc(cipherLen);
        [cipherData getBytes:cipher length:cipherLen];
        int plainLen = (int)(blockSize - 11);
        void *plain = malloc(plainLen);
        // 下面两行是公钥加密，私钥解密
        int count = rsa.prikey_decrypt((unsigned char *)cipher, (int)cipherLen, (unsigned char **)&plain, plainLen);
        if (count <= 0) {
            return nil;
        }
        NSData *decryptedBytes = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
        [decryptedData appendData:decryptedBytes];
    }
    rsa.close_key();
    return decryptedData;
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(PEM证书格式)，先解码16进制，再解密
 *
 *  @param content     需要解密的密文内容
 *  @param pemFilePath pem私钥证书的路径，绝对路径
 *  @param password    pem私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath password:(NSString *)password {
    return [self rsaPrivateKeyDecryptString:content pemFilePath:pemFilePath password:password padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(PEM证书格式)
 *
 *  @param data        需要解密的密文二进制
 *  @param pemFilePath pem私钥证书的路径，绝对路径
 *  @param password    pem私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath password:(NSString *)password {
    return [self rsaPrivateKeyDecryptData:data pemFilePath:pemFilePath password:password padding:RSA_PKCS1_PADDING];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(PEM证书格式)，先解码16进制，再解密
 *
 *  @param content     需要解密的密文内容
 *  @param pemFilePath pem私钥证书的路径，绝对路径
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath {
    return [self rsaPrivateKeyDecryptString:content pemFilePath:pemFilePath password:nil];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(PEM证书格式)
 *
 *  @param data        需要解密的密文二进制
 *  @param pemFilePath pem私钥证书的路径，绝对路径
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath {
    return [self rsaPrivateKeyDecryptData:data pemFilePath:pemFilePath password:nil];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(CER证书格式)，对应要用RSA私钥解密，加密后转成16进制字符串
 *
 *  @param content     需要加密的原始内容
 *  @param cerFilePath cer公钥证书的路径，绝对路径
 *  @param padding     加密格式
 *
 *  @return 加密后内容
 */
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content cerFilePath:(NSString *)cerFilePath padding:(SecPadding)padding {
    NSData *encryptData = [self rsaPublicKeyEncryptData:[NSData fyf_dataWithString:content] cerFilePath:cerFilePath padding:padding];
    return [FYFHexHelper hexStringFromData:encryptData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(CER证书格式)，对应要用RSA私钥解密
 *
 *  @param data        需要加密的原始二进制
 *  @param cerFilePath cer公钥证书的路径，绝对路径
 *  @param padding     加密格式
 *
 *  @return 加密后内容
 */
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data cerFilePath:(NSString *)cerFilePath padding:(SecPadding)padding {
    SecKeyRef publicKey = [self getPublicKeyFile:cerFilePath];
    if (publicKey) {
        size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
        uint8_t *cipherBuffer = (uint8_t *)malloc(cipherBufferSize * sizeof(uint8_t));
        size_t blockSize = cipherBufferSize - 11;
        size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
        NSMutableData *encryptedData = [[NSMutableData alloc] init];
        for (int i = 0; i < blockCount; i ++) {
            int bufferSize = (int)MIN(blockSize,[data length] - i * blockSize);
            NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
            OSStatus status = SecKeyEncrypt(publicKey, padding, (const uint8_t *)[buffer bytes],
                                            [buffer length], cipherBuffer, &cipherBufferSize);
            if (status == noErr) {
                NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
                [encryptedData appendData:encryptedBytes];
            } else {
                if (cipherBuffer) {
                    free(cipherBuffer);
                }
                return nil;
            }
        }
        if (cipherBuffer) {
            free(cipherBuffer);
        }
        return encryptedData;
    }
    return nil;
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(CER证书格式)，对应要用RSA私钥解密，加密后转成16进制字符串
 *
 *  @param content     需要加密的原始内容
 *  @param cerFilePath cer公钥证书的路径，绝对路径
 *
 *  @return 加密后内容
 */
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content cerFilePath:(NSString *)cerFilePath {
    return [self rsaPublicKeyEncryptString:content cerFilePath:cerFilePath padding:kSecPaddingPKCS1];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:06
 *
 *  RSA公钥加密(CER证书格式)，对应要用RSA私钥解密
 *
 *  @param data        需要加密的原始二进制
 *  @param cerFilePath cer公钥证书的路径，绝对路径
 *
 *  @return 加密后内容
 */
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data cerFilePath:(NSString *)cerFilePath {
    return [self rsaPublicKeyEncryptData:data cerFilePath:cerFilePath padding:kSecPaddingPKCS1];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(P12证书格式)，先解码16进制，再解密
 *
 *  @param content     需要解密的密文内容
 *  @param p12FilePath p12私钥证书的路径，绝对路径
 *  @param password    p12私钥证书密码
 *  @param padding     加密格式
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content p12FilePath:(NSString *)p12FilePath password:(NSString *)password padding:(SecPadding)padding {
    NSData *decryptData = [self rsaPrivateKeyDecryptData:[FYFHexHelper dataFromHexString:content] p12FilePath:p12FilePath password:password padding:padding];
    return [NSData fyf_stringWithData:decryptData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(P12证书格式)
 *
 *  @param data        需要解密的密文二进制
 *  @param p12FilePath p12私钥证书的路径，绝对路径
 *  @param password    p12私钥证书密码
 *  @param padding     加密格式
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data p12FilePath:(NSString *)p12FilePath password:(NSString *)password padding:(SecPadding)padding {
    SecKeyRef privateKey = [self getPrivateKeyFile:p12FilePath password:password];
    if (privateKey) {
        size_t blockSize = SecKeyGetBlockSize(privateKey);
        size_t blockNum = data.length / blockSize;
        NSMutableData *decryptedData = [[NSMutableData alloc] init];
        for(int i = 0; i < blockNum; i ++) {
            NSData *cipherData = [data subdataWithRange:NSMakeRange(i * blockSize, blockSize)];
            size_t cipherLen = [cipherData length];
            void *cipher = malloc(cipherLen);
            [cipherData getBytes:cipher length:cipherLen];
            size_t plainLen = blockSize - 11;
            void *plain = malloc(plainLen);
            OSStatus status = SecKeyDecrypt(privateKey, padding,(const uint8_t *)cipher, cipherLen, (uint8_t*)plain, &plainLen);
            if (status != noErr) {
                return nil;
            }
            NSData *decryptedBytes = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
            [decryptedData appendData:decryptedBytes];
        }
        return decryptedData;
    }
    return nil;
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(P12证书格式)，先解码16进制，再解密
 *
 *  @param content     需要解密的密文内容
 *  @param p12FilePath p12私钥证书的路径，绝对路径
 *  @param password    p12私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content p12FilePath:(NSString *)p12FilePath password:(NSString *)password {
    return [self rsaPrivateKeyDecryptString:content p12FilePath:p12FilePath password:password padding:kSecPaddingPKCS1];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(P12证书格式)
 *
 *  @param data        需要解密的密文二进制
 *  @param p12FilePath p12私钥证书的路径，绝对路径
 *  @param password    p12私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data p12FilePath:(NSString *)p12FilePath password:(NSString *)password {
    return [self rsaPrivateKeyDecryptData:data p12FilePath:p12FilePath password:password padding:kSecPaddingPKCS1];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(P12证书格式)，先解码16进制，再解密
 *
 *  @param content     需要解密的密文内容
 *  @param p12FilePath p12私钥证书的路径，绝对路径
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content p12FilePath:(NSString *)p12FilePath {
    return [self rsaPrivateKeyDecryptString:content p12FilePath:p12FilePath password:nil];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  RSA私钥解密(P12证书格式)
 *
 *  @param data        需要解密的密文二进制
 *  @param p12FilePath p12私钥证书的路径，绝对路径
 *  @param password    p12私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data p12FilePath:(NSString *)p12FilePath {
    return [self rsaPrivateKeyDecryptData:data p12FilePath:p12FilePath password:nil];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  通用RSA证书私钥文件解密(P12/PEM证书格式)，先解码16进制，再解密
 *
 *  @param content            需要解密的密文内容
 *  @param privateKeyFilePath P12/PEM私钥证书的路径，绝对路径
 *  @param password           P12/PEM私钥证书密码
 *  @param padding            加密格式，目前支持(kSecPaddingNone=0,kSecPaddingPKCS1=1,kSecPaddingOAEP=2)
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password padding:(SecPadding)padding {
    NSData *decryptData = [self rsaPrivateKeyDecryptData:[FYFHexHelper dataFromHexString:content] privateKeyFilePath:privateKeyFilePath password:password padding:padding];
    return [NSData fyf_stringWithData:decryptData];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  通用RSA证书私钥文件解密(P12/PEM证书格式)
 *
 *  @param data               需要解密的密文二进制
 *  @param privateKeyFilePath P12/PEM私钥证书的路径，绝对路径
 *  @param password           P12/PEM私钥证书密码
 *  @param padding            加密格式，目前支持(kSecPaddingNone=0,kSecPaddingPKCS1=1,kSecPaddingOAEP=2)
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password padding:(SecPadding)padding {
    NSString *fileExtend = privateKeyFilePath.pathExtension;
    if ([[fileExtend lowercaseString]isEqualToString:@"pem"]) {
        int pemPadding = RSA_PKCS1_PADDING;
        if (padding == kSecPaddingNone) {
            pemPadding = RSA_NO_PADDING;
        } else if (padding == kSecPaddingPKCS1) {
            pemPadding = RSA_PKCS1_PADDING;
        } else if (padding == kSecPaddingOAEP) {
            pemPadding = RSA_PKCS1_OAEP_PADDING;
        }
        return [self rsaPrivateKeyDecryptData:data pemFilePath:privateKeyFilePath password:password padding:pemPadding];
    } else {
        return [self rsaPrivateKeyDecryptData:data p12FilePath:privateKeyFilePath password:password padding:padding];
    }
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  通用RSA证书私钥文件解密(P12/PEM证书格式)，先解码16进制，再解密
 *
 *  @param content            需要解密的密文内容
 *  @param privateKeyFilePath P12/PEM私钥证书的路径，绝对路径
 *  @param password           P12/PEM私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password {
    return [self rsaPrivateKeyDecryptString:content privateKeyFilePath:privateKeyFilePath password:password padding:kSecPaddingPKCS1];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  通用RSA证书私钥文件解密(P12/PEM证书格式)
 *
 *  @param data               需要解密的密文二进制
 *  @param privateKeyFilePath P12/PEM私钥证书的路径，绝对路径
 *  @param password           P12/PEM私钥证书密码
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password {
    return [self rsaPrivateKeyDecryptData:data privateKeyFilePath:privateKeyFilePath password:password padding:kSecPaddingPKCS1];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  通用RSA证书私钥文件解密(P12/PEM证书格式)，先解码16进制，再解密
 *
 *  @param content            需要解密的密文内容
 *  @param privateKeyFilePath P12/PEM私钥证书的路径，绝对路径
 *
 *  @return 解密后内容
 */
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content privateKeyFilePath:(NSString *)privateKeyFilePath {
    return [self rsaPrivateKeyDecryptString:content privateKeyFilePath:privateKeyFilePath password:nil];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:02
 *
 *  通用RSA证书私钥文件解密(P12/PEM证书格式)
 *
 *  @param data               需要解密的密文二进制
 *  @param privateKeyFilePath P12/PEM私钥证书的路径，绝对路径
 *
 *  @return 解密后内容
 */
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data privateKeyFilePath:(NSString *)privateKeyFilePath {
    return [self rsaPrivateKeyDecryptData:data privateKeyFilePath:privateKeyFilePath password:nil];
}

/**
 *  @author fanyunfei, 2016-11-16 17:11:33
 *
 *  获取公钥
 *
 *  @param certPath 证书地址，绝对路径
 *
 *  @return 公钥
 */
+ (SecKeyRef) getPublicKeyFile:(NSString *)certPath {
    NSData *certificateData = [NSData dataWithContentsOfFile:certPath];
    if (certificateData == nil) {
        return nil;
    }
    SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    } else {
        return nil;
    }
    SecKeyRef public_key = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    return public_key;
}

/**
 *  @author fanyunfei, 2016-11-16 17:11:44
 *
 *  获取私钥
 *
 *  @param certPath 证书私钥路径，绝对路径
 *
 *  @return 私钥
 */
+ (SecKeyRef) getPrivateKeyFile:(NSString *)certPath password:(NSString *)password {
    NSData *p12Data = [[NSData alloc]initWithContentsOfFile:certPath];
    if (p12Data == nil) {
        return nil;
    }
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    if (!fyf_empty(password)) {
        [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
    }
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = (CFDictionaryRef)CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    } else {
    }
    CFRelease(items);
    return privateKeyRef;
}


@end
