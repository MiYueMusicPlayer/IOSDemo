//
//  NSString+regular.h
//  LZH
//
//  Created by Mac1 on 2017/4/8.
//  Copyright © 2017年 Mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (regular)

- (CGSize)sizeWithTextfont:(UIFont *)font maxSize:(CGSize)maxSize;

- (NSMutableArray *)changeWithString;

/**
 *  判断是否为邮箱
 *
 *  @return 是否为邮箱
 */
- (BOOL)checkMailInput;

/**
 *  判断是否为手机号码
 *
 *  @return 是否为手机号码
 */
- (BOOL)checkTel;

- (BOOL)checkIdentityCard;

- (NSString *)getIdentityCardAge;

- (NSString *)birthdayStrFromIdentityCard;
//- (NSString *)returnBankName;

- (BOOL)checkBankCard;
/**
 *  32位MD5加密
 *
 *  @return 32位MD5加密
 */
- (NSString *)MD5;

- (CGFloat)heightOfWidth:(CGFloat)width font:(UIFont *)font;

- (NSString *)createdTime;

- (BOOL)cheackNULL;

-(id)JSONValue;

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

- (BOOL)isURL;

@end
