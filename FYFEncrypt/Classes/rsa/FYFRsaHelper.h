//
//  FYFRsaHelper.h
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*********padding定义***********
# define RSA_PKCS1_PADDING       1
# define RSA_SSLV23_PADDING      2
# define RSA_NO_PADDING          3
# define RSA_PKCS1_OAEP_PADDING  4
# define RSA_X931_PADDING        5
# define RSA_PKCS1_PSS_PADDING   6
******************************/

/**
 *  @Author fanyunfei, 2015-07-14 13:07:46
 *
 *  RSA加解密
 */

@interface FYFRsaHelper : NSObject


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
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pubExpd:(NSString *)pubExpd module:(NSString *)module padding:(int)padding;

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
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pubExpd:(NSString *)pubExpd module:(NSString *)module padding:(int)padding;

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
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pubExpd:(NSString *)pubExpd module:(NSString *)module;

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
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pubExpd:(NSString *)pubExpd module:(NSString *)module;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module padding:(int)padding;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module padding:(int)padding;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pubExpd:(NSString *)pubExpd privExpd:(NSString *)privExpd module:(NSString *)module;

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
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath padding:(int)padding;

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
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath padding:(int)padding;

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
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath;

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
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath password:(NSString *)password padding:(int)padding;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath password:(NSString *)password  padding:(int)padding;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath password:(NSString *)password;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath password:(NSString *)password;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content pemFilePath:(NSString *)pemFilePath;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data pemFilePath:(NSString *)pemFilePath;

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
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content cerFilePath:(NSString *)cerFilePath padding:(SecPadding)padding;

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
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data cerFilePath:(NSString *)cerFilePath padding:(SecPadding)padding;

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
+ (NSString *)rsaPublicKeyEncryptString:(NSString *)content cerFilePath:(NSString *)cerFilePath;

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
+ (NSData *)rsaPublicKeyEncryptData:(NSData *)data cerFilePath:(NSString *)cerFilePath;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content p12FilePath:(NSString *)p12FilePath password:(NSString *)password padding:(SecPadding)padding;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data p12FilePath:(NSString *)p12FilePath password:(NSString *)password padding:(SecPadding)padding;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content p12FilePath:(NSString *)p12FilePath password:(NSString *)password;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data p12FilePath:(NSString *)p12FilePath password:(NSString *)password;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content p12FilePath:(NSString *)p12FilePath;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data p12FilePath:(NSString *)p12FilePath;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password padding:(SecPadding)padding;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password padding:(SecPadding)padding;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data privateKeyFilePath:(NSString *)privateKeyFilePath password:(NSString *)password;

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
+ (NSString *)rsaPrivateKeyDecryptString:(NSString *)content privateKeyFilePath:(NSString *)privateKeyFilePath;

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
+ (NSData *)rsaPrivateKeyDecryptData:(NSData *)data privateKeyFilePath:(NSString *)privateKeyFilePath;


@end

NS_ASSUME_NONNULL_END
