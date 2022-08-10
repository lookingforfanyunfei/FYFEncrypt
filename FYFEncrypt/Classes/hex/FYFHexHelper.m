//
//  FYFHexHelper.m
//  FYFEncrypt
//
//  Created by 范云飞 on 2021/9/14.
//

#import "FYFHexHelper.h"
#import <FYFCategory/NSObject+FYFExtension.h>
#import <FYFCategory/NSData+FYFExtension.h>

@implementation FYFHexHelper


/**
 *  普通字符串转成16进制字符串
 *
 *  @param string 字符串
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string {
    if (!fyf_empty(string)) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        return [FYFHexHelper hexStringFromData:data];
    }
    return @"";
}

/**
 *  数据转成16进制字符串
 *
 *  @param data 数据
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromData:(NSData *)data {
    if(data && data.length > 0) {
        Byte *bytes = (Byte *)[data bytes];
        //下面是Byte 转换为16进制。
        NSString *hexStr = @"";
        for(int i = 0; i < [data length]; i ++) {
            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
            if([newHexStr length] == 1) {
                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
            } else {
                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
            }
        }
        return hexStr;
    }
    return @"";
}

/**
 *  char字符串转成16进制字符串
 *
 *  @param bytes 数据
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromChar:(char *)bytes {
    NSData *data = [NSData fyf_dataWithChars:bytes];
    return [self hexStringFromData:data];
}

/**
 *  普通字符串转成16进制数据
 *
 *  @param string 字符串
 *
 *  @return 16进制数据
 */
+ (NSData *)hexDataFromString:(NSString *)string {
    if (!fyf_empty(string)) {
        NSString *hexStr = [FYFHexHelper hexStringFromString:string];
        return [hexStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSData data];
}

/**
 *  数据转成16进制数据
 *
 *  @param data 数据
 *
 *  @return 16进制数据
 */
+ (NSData *)hexDataFromData:(NSData *)data {
    if (data && data.length > 0)
    {
        NSString *str = [FYFHexHelper hexStringFromData:data];
        return [str dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSData data];
}

/**
 *  16进制字符串转成普通字符串
 *
 *  @param hexString 16进制字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString {
    if (!fyf_empty(hexString)) {
        char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
        bzero(myBuffer, [hexString length] / 2 + 1);
        for (int i = 0; i < [hexString length] - 1; i += 2) {
            unsigned int anInt;
            NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
            NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            myBuffer[i / 2] = (char)anInt;
        }
        NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];
        return unicodeString;
    }
    return @"";
}

/**
 *  16进制数据转成普通字符串
 *
 *  @param data 16进制数据
 *
 *  @return 普通字符串
 */
+ (NSString *)stringFromHexData:(NSData *)data {
    if (data && data.length > 0) {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return [FYFHexHelper stringFromHexString:str];
    }
    return @"";
}

/**
 *  16进制字符串转成普通数据
 *
 *  @param data 16进制字符串
 *
 *  @return 普通数据
 */
+ (NSData *)dataFromHexString:(NSString *)hexString {
    if (!fyf_empty(hexString)) {
        NSString *str = [FYFHexHelper stringFromHexString:hexString];
        return [str dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSData data];
}

/**
 *  16进制数据转成普通数据
 *
 *  @param data 16进制数据
 *
 *  @return 普通数据
 */
+ (NSData *)dataFromHexData:(NSData *)data {
    if (data && data.length > 0) {
        NSString *str = [FYFHexHelper stringFromHexData:data];
        return [str dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSData data];
}

/**
 *  @Author fanyunfei, 2015-07-14 13:07:43
 *
 *  16进制字符串转换成字符数组
 *
 *  @param hexString 16进制字符串
 *
 *  @return 字符数组
 */
+ (char *)charFromHexString:(NSString *)hexString {
    if (!fyf_empty(hexString)) {
        char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
        bzero(myBuffer, [hexString length] / 2 + 1);
        for (int i = 0; i < [hexString length] - 1; i += 2) {
            unsigned int anInt;
            NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
            NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            myBuffer[i / 2] = (char)anInt;
        }
        return myBuffer;
    }
    return NULL;
}


/**
 *  10进制数字转成16进制的字符串
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromInteger:(NSInteger)value {
    return [NSString stringWithFormat:@"0x%x",(int)value];
}

/**
 *  10进制数字字符串转成16进制的字符串
 *
 *  @return 16进制字符串
 */
+ (NSString *)hexStringFromIntegerString:(NSString *)integerStr {
    return [NSString stringWithFormat:@"0x%x",integerStr.intValue];
}

/**
 *  16进制字符串转成10进制数字
 *
 *  @return 10进制数字
 */
+ (NSInteger)integerFromHexString:(NSString *)hexString {
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    }
    return strtoul([hexString UTF8String],0,16);
}

/**
 *  16进制字符串转成10进制数字字符串
 *
 *  @return 10进制数字字符串
 */
+ (NSString *)integerStringFromHexString:(NSString *)hexString {
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    }
    return [NSString stringWithFormat:@"%lu",strtoul([hexString UTF8String],0,16)];
}


@end
