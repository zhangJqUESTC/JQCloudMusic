//
//  PreferenceUtil.h
//  JQCloudMusic
//  偏好设置的封装
//  Created by zhangjq on 2024/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceUtil : NSObject
#pragma mark - 用户

/// 设置用户Id
/// @param data data description
+(void)setUserId:(NSString *)data;

/// 获取用户Id
+(NSString *)getUserId;

/// 设置用户session
/// @param data data description
+(void)setSession:(NSString *)data;

/// 获取用户session
+(NSString *)getSession;

/// 设置聊天session
/// @param data data description
+(void)setChatSession:(NSString *)data;

/// 获取聊天session
+(NSString *)getChatSession;

/// 是否登录了
+(BOOL)isLogin;

/// 退出
+(void)logout;
@end

NS_ASSUME_NONNULL_END
