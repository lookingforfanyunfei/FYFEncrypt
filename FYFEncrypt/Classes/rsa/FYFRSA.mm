//
//  FYFRsa.cpp
//  FYFUtil_V1
//
//  Created by fanyunfei on 15-7-14.
//  Copyright (c) 2015年 fanyunfei. All rights reserved.
//

#include <stdio.h>
#include <string.h>

#ifndef __FYFUtil_V1__FYFRSA__
#define __FYFUtil_V1__FYFRSA__
#include <OpenSSL/rsa.h>
#include <OpenSSL/pem.h>
#include <OpenSSL/err.h>
#define RSA_KEY_LENGTH 1024

static const char rnd_seed[] = "string to make the random number generator initialized";

class FYFRSA
{
public:
    FYFRSA();
    ~FYFRSA();
    
    // init params
    int set_params(unsigned char *pub_expd, int pub_expd_len,
                   unsigned char *pri_expd, int pri_expd_len,
                   unsigned char *module, int module_len, int padding);
    
    // open keys
    int open_prikey_pubkey();
    int open_prikey();
    int open_pubkey();
    
    //open pem文件
    int open_prikey_pubkey_pemfile(char *pri_key_path,char *pub_key_path, char* password,int padding);
    int open_prikey_pemfile(char *pri_key_path, char* password,int padding);
    int open_pubkey_pemfile(char *pub_key_path, int padding);
    int getBlockSize();
    
    // private key to encryption and public key to decryption
    int prikey_encrypt(unsigned char *in, int in_len,
                       unsigned char **out, int &out_len);
    int pubkey_decrypt(unsigned char *in, int in_len,
                       unsigned char **out, int &out_len);
    // public key to encryption and private key to decryption
    int pubkey_encrypt(unsigned char *in, int in_len,
                       unsigned char **out, int &out_len);
    int prikey_decrypt(unsigned char *in, int in_len,
                       unsigned char **out, int &out_len);
    
    int close_key();
protected:
    void free_res();
    
private:
    RSA *_pub_key;
    RSA *_pri_key;
    
    unsigned char *_pub_expd;
    unsigned char *_pri_expd;
    unsigned char *_module;
    
    int _pub_expd_len;
    int _pri_expd_len;
    int _module_len;
    int _padding;
};

#endif


FYFRSA::FYFRSA()
{
    _pub_key = NULL;
    _pri_key = NULL;
    _pub_expd = NULL;
    _pri_expd = NULL;
    _module = NULL;
    _pub_expd_len = 0;
    _pri_expd_len = 0;
    _module_len = 0;
    _padding = RSA_PKCS1_PADDING;
    OpenSSL_add_all_algorithms();
}

FYFRSA::~FYFRSA()
{
    close_key();
    free_res();
}

// 初始化参数
int FYFRSA::set_params(unsigned char *pub_expd, int pub_expd_len,
                      unsigned char *pri_expd, int pri_expd_len,
                      unsigned char *module, int module_len,int padding)
{
    if(pub_expd)
    {
        _pub_expd_len = pub_expd_len;
        _pub_expd = new unsigned char[pub_expd_len];
        if(!_pub_expd)
        {
            free_res();
            return -1;
        }
        memcpy(_pub_expd, pub_expd, _pub_expd_len);
    }
    if(pri_expd)
    {
        _pri_expd_len = pri_expd_len;
        _pri_expd = new unsigned char[pri_expd_len];
        if(!_pri_expd)
        {
            free_res();
            return -1;
        }
        memcpy(_pri_expd, pri_expd, pri_expd_len);
    }
    if(module)
    {
        _module_len = module_len;
        _module = new unsigned char[module_len];
        if(!_module)
        {
            free_res();
            return -1;
        }
        memcpy(_module, module, module_len);
    }
    _padding = padding;
    return 0;
}

// 在一个key中同时打开公钥和私钥，该key既可用作公钥函数，也可用作私钥函数
int FYFRSA::open_prikey_pubkey()
{
    //构建RSA数据结构
    _pri_key = RSA_new();
    
    const BIGNUM * bn_e;
//    _pri_key->e = BN_bin2bn(_pub_expd, _pub_expd_len, _pri_key->e);
//    _pri_key->d = BN_bin2bn(_pri_expd, _pri_expd_len, _pri_key->d);
//    _pri_key->n = BN_bin2bn(_module, _module_len, _pri_key->n);
    RSA_print_fp(stdout, _pri_key, 0);
    return 0;
}
 
// 打开私钥
int FYFRSA::open_prikey()
{
    //构建RSA数据结构
    _pri_key = RSA_new();
//    _pri_key->d = BN_bin2bn(_pri_expd, _pri_expd_len, _pri_key->d);
//    _pri_key->n = BN_bin2bn(_module, _module_len, _pri_key->n);
    RSA_print_fp(stdout, _pri_key, 0);
    return 0;
}

// 打开公钥
int FYFRSA::open_pubkey()
{
    //构建RSA数据结构
    _pub_key = RSA_new();
//    _pub_key->e = BN_bin2bn(_pub_expd, _pub_expd_len, _pub_key->e);
//    _pub_key->n = BN_bin2bn(_module, _module_len, _pub_key->n);
    RSA_print_fp(stdout, _pub_key, 0);
    return 0;
}

//open pem文件
int FYFRSA::open_prikey_pubkey_pemfile(char *pri_key_path,char *pub_key_path, char* password,int padding)
{
    _padding = padding;
    FILE *file;
    if((file=fopen(pri_key_path,"r"))==NULL)
    {
        perror("open key file error");
        return -1;
    }
    if((_pri_key = PEM_read_RSAPrivateKey(file,NULL,NULL,password))==NULL)
    {
        ERR_print_errors_fp(stdout);
        return NULL;
    }
    RSA_print_fp(stdout, _pri_key, 0);
    fclose(file);
    if((file=fopen(pub_key_path,"r"))==NULL)
    {
        perror("open key file error");
        return -1;
    }
    if((_pub_key=PEM_read_RSA_PUBKEY(file,NULL,NULL,NULL))==NULL)
    {
        ERR_print_errors_fp(stdout);
        return -1;
    }
    RSA_print_fp(stdout, _pub_key, 0);
    fclose(file);
    return 0;
}

int FYFRSA::open_prikey_pemfile(char *pri_key_path, char* password,int padding)
{
    _padding = padding;
    FILE *file;
    if((file=fopen(pri_key_path,"r"))==NULL)
    {
        perror("open key file error");
        return -1;
    }
    if((_pri_key = PEM_read_RSAPrivateKey(file,NULL,NULL,password))==NULL)
    {
        ERR_print_errors_fp(stdout);
        return NULL;
    }
    RSA_print_fp(stdout, _pri_key, 0);
    fclose(file);
    return 0;
}

int FYFRSA::open_pubkey_pemfile(char *pub_key_path, int padding)
{
    _padding = padding;
    FILE *file;
    if((file=fopen(pub_key_path,"r"))==NULL)
    {
        perror("open key file error");
        return -1;
    }
    if((_pub_key=PEM_read_RSA_PUBKEY(file,NULL,NULL,NULL))==NULL)
    {
        ERR_print_errors_fp(stdout);
        return -1;
    }
    RSA_print_fp(stdout, _pub_key, 0);
    fclose(file);
    return 0;
}

int FYFRSA::getBlockSize()
{
    if (_pub_key)
    {
        return RSA_size(_pub_key);
    }
    else  if (_pri_key)
    {
        return RSA_size(_pri_key);
    }
    return 0;
}

// 私钥加密函数
int FYFRSA::prikey_encrypt(unsigned char *in, int in_len,
                          unsigned char **out, int &out_len)
{
    out_len =  RSA_size(_pri_key);
    *out =  (unsigned char *)malloc(out_len);
    if(NULL == *out)
    {
        printf("prikey_encrypt:malloc error!\n");
        return -1;
    }
    memset((void *)*out, 0, out_len);
    printf("prikey_encrypt:Begin RSA_private_encrypt ...\n");
    int ret =  RSA_private_encrypt(in_len, in, *out, _pri_key, _padding);
    //RSA_public_decrypt(flen, encData, decData, r,  RSA_NO_PADDING);
    return ret;
}

// 公钥解密函数，返回解密后的数据长度
int FYFRSA::pubkey_decrypt(unsigned char *in, int in_len,
                          unsigned char **out, int &out_len)
{
    *out =  (unsigned char *)malloc(out_len);
    if(NULL == *out)
    {
        printf("pubkey_decrypt:malloc error!\n");
        return -1;
    }
    memset((void *)*out, 0, out_len);
    printf("pubkey_decrypt:Begin RSA_public_decrypt ...\n");
    int ret =  RSA_public_decrypt(in_len, in, *out, _pub_key, _padding);
    return ret;
}

// 公钥加密函数
int FYFRSA::pubkey_encrypt(unsigned char *in, int in_len,
                          unsigned char **out, int &out_len)
{
    out_len =  RSA_size(_pub_key);
    *out =  (unsigned char *)malloc(out_len);
    if(NULL == *out)
    {
        printf("pubkey_encrypt:malloc error!\n");
        return -1;
    }
    memset((void *)*out, 0, out_len);
    printf("pubkey_encrypt:Begin RSA_public_encrypt ...\n");
    int ret =  RSA_public_encrypt(in_len, in, *out, _pub_key, _padding);
    return ret;
}

// 私钥解密函数，返回解密后的长度
int FYFRSA::prikey_decrypt(unsigned char *in, int in_len,
                          unsigned char **out, int &out_len)
{
    *out =  (unsigned char *)malloc(out_len);
    if(NULL == *out)
    {
        printf("prikey_decrypt:malloc error!\n");
        return -1;
    }
    memset((void *)*out, 0, out_len);
    printf("prikey_decrypt:Begin RSA_private_decrypt ...\n");
    int ret =  RSA_private_decrypt(in_len, in, *out, _pri_key, _padding);
    return ret;
}

// 释放分配的内存资源
void FYFRSA::free_res()
{
    if(_pub_expd)
    {
        delete []_pub_expd;
        _pub_expd = NULL;
    }
    if(_pri_expd)
    {
        delete []_pri_expd;
        _pri_expd = NULL;
    }
    if(_module)
    {
        delete []_module;
        _module = NULL;
    }
}

// 释放公钥和私钥结构资源
int FYFRSA::close_key()
{
    if(_pub_key)
    {
        RSA_free(_pub_key);
        _pub_key = NULL;
    }
    if(_pri_key)
    {
        RSA_free(_pri_key);
        _pri_key = NULL;
    }
    return 0;
}

void RSA_get_key(const RSA *r,const BIGNUM *n,const BIGNUM *e,const BIGNUM *d)
{
    if (n != NULL) {
//        *n = r -> n;
    }
}

//void RSA_get0_key（const RSA * r，const BIGNUM ** n，const BIGNUM ** e，const BIGNUM ** d）
//{
//   if（n！=空）
//        * n = r-> n;
//    if（e！= NULL）
//        * e = r-> e;
//    如果（d！= NULL）
//        * d = r-> d;
//}
