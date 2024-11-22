//
//  MusicPlayerManager.h
//  JQCloudMusic
//  播放管理器实现
//  封装了常用的音乐播放功能
//  例如：播放，暂停，继续播放等功能
//  目的就是对外面提供统一的接口
//  好处是内部自由的重构
//  只需要对外部接口不变
// （现在是使用系统自带的播放器，如果以后要换成第三方的播放器，就只需要更改这个类就行）
//  Created by zhangjq on 2024/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///播放完毕回调block
typedef void(^MusicPlayerManagerComplete)(Song *data);

/// 播放管理器代理
@protocol MusicPlayerManagerDelegate<NSObject>

/// 播放器准备完毕了
/// 可以获取到音乐总时长
- (void)onPrepared:(Song *)data;

/// 暂停了
/// @param data data description
- (void)onPaused:(Song *)data;

/// 正在播放
/// @param data data description
- (void)onPlaying:(Song *)data;

/// 进度回调
/// @param data data description
- (void)onProgress:(Song *)data;

/// 歌词数据准备好了
/// @param data data description
- (void)onLyricReady:(Song *)data;
@end


@interface MusicPlayerManager : NSObject
/// 代理对象，目的是将不同的状态分发出去
@property (nonatomic, weak, nullable) id <MusicPlayerManagerDelegate> delegate;

/// 播放完毕block
@property (nonatomic, strong, nullable) MusicPlayerManagerComplete complete;

/// 当前音乐
@property(nonatomic, strong) Song *data;

/// 获取单例对象
+(instancetype)shared;

/**
 播放
 @param data data description
 */
- (void)play:(NSString *)uri data:(Song *)data;

/**
 * 是否在播放
 */
- (BOOL)isPlaying;

/**
 * 暂停
 */
- (void)pause;

/**
 * 继续播放
 */
- (void)resume;

/**
 * 移动到指定位置播放
 * @param data 播放进度
 */
- (void)seekTo:(float)data;

-(void)prepareLyric;
@end

NS_ASSUME_NONNULL_END
