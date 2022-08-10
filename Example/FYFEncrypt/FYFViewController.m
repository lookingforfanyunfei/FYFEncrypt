//
//  FYFViewController.m
//  FYFEncrypt
//
//  Created by 786452470@qq.com on 08/09/2022.
//  Copyright (c) 2022 786452470@qq.com. All rights reserved.
//

#import "FYFViewController.h"
#import <FYFEncrypt/FYFDesHelper.h>
#import <FYFEncrypt/FYFAesHelper.h>
#import <FYFEncrypt/FYFMD5Helper.h>
#import <FYFEncrypt/FYFBase64Helper.h>
#import <FYFEncrypt/FYFRsaHelper.h>

#define KSecretKey @"KSecretKey"

@interface FYFViewController ()

@end

@implementation FYFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *text = @"http://10.253.50.195/appsystem/app/index.html#/HighSeaCustomer";
    
    NSString *encodeBase64String = [FYFBase64Helper stringWithWebSafeEncodeBase64String:text];
    NSString *decondeBase64String = [FYFBase64Helper stringWithWebSafeDecodeBase64String:encodeBase64String];
    NSLog(@"decondeBase64String:%@",decondeBase64String);
    
    NSData *descipher = [FYFDesHelper dataWithDesEncryptString:text withKey:KSecretKey];
    NSData *desPlain = [FYFDesHelper dataWithDesDecryptData:descipher withKey:KSecretKey];
    /// http://10.253.50.195/appsystem/app/index.html#/HighSeaCustomer
    NSLog(@"desPlain:%@", [[NSString alloc] initWithData:desPlain encoding:NSUTF8StringEncoding]);
    
    NSString *aescipher = [FYFAesHelper stringWithAesEncryptString:text withKey:KSecretKey];
    NSString *aesPlain = [FYFAesHelper stringWithAesDecryptString:aescipher withKey:KSecretKey];
    /// http://10.253.50.195/appsystem/app/index.html#/HighSeaCustomer
    NSLog(@"aesPlain:%@", aesPlain);
    
    NSString *md5cipher = [FYFMD5Helper md5Encrypt:text];
    ///4f7014a038901294bd0b6ea672b804a4
    NSLog(@"md5cipher:%@",md5cipher);

    NSString *pubPemPath = [[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"pem"];
    NSString *privatePemPath = [[NSBundle mainBundle] pathForResource:@"rsa_private_key" ofType:@"pem"];
    NSData *cipherData = [FYFRsaHelper rsaPublicKeyEncryptData:[md5cipher dataUsingEncoding:NSUTF8StringEncoding] pemFilePath:pubPemPath];
    NSData *plainData = [FYFRsaHelper rsaPrivateKeyDecryptData:cipherData pemFilePath:privatePemPath];
    NSString *plaintext = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    /// 4f7014a038901294bd0b6ea672b804a4
    NSLog(@"plain:%@",plaintext);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
