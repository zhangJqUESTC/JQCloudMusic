//
//  StringUtil.h
//  JQCloudMusic
//  字符串相关工具类
//  Created by zhangjq on 2024/10/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringUtil : NSObject
/// 是否是空白字符串
/// @param data data description
+ (BOOL)isBlank:(NSString *)data;

/// 是否不是空白字符串
/// @param data data description
+ (BOOL)isNotBlank:(NSString *)data;

/// 是否符合密码格式
/// @param data <#data description#>
+ (BOOL)isPassword:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
