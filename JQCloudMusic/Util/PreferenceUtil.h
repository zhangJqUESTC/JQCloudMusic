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

#pragma mark - 播放

/// 获取最后播放的音乐Id
+(NSString *)getLastPlaySongId;

/// 设置当前播放音乐的id
/// @param data data description
+(void)setLastPlaySongId:(NSString *)data;

/// 移除音频输出设备（包括蓝牙耳机，音响）是否暂停音乐播放
+(BOOL)isUnplugHeadsetStopMusic;

/// 设置移除音频输出设备（包括蓝牙耳机，音响）是否暂停音乐播放
/// @param data data description
+(void)setUnplugHeadsetStopMusic:(BOOL)data;
@end

NS_ASSUME_NONNULL_END
