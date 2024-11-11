//
//  MusicListManager.h
//  JQCloudMusic
//  列表管理器
//  Created by zhangjq on 2024/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//音乐循环状态
typedef NS_ENUM(NSInteger, MusicPlayRepeatModel) {
    MusicPlayRepeatModelList, //列表循环
    MusicPlayRepeatModelOne, //单曲循环
    MusicPlayRepeatModelRandom //列表随机
};

@interface MusicListManager : NSObject

/// 获取单例对象
+(instancetype)shared;
/// 设置播放列表
- (void)setDatum:(NSArray *)datum;

/// 获取播放列表
- (NSArray *)getDatum;

/**
 * 播放
 */
- (void)play:(Song *)data;

/**
 * 暂停
 */
- (void)pause;

/**
 * 继续播放
 */
- (void)resume;

/**
 * 获取当前播放的音乐
 */
- (Song *)getData;

/**
 * 更改循环模式
 */
- (MusicPlayRepeatModel)changeLoopModel;

/**
 * 获取循环模式
 */
- (MusicPlayRepeatModel)getLoopModel;

/**
 * 获取上一个
 */
- (Song *)previous;

/**
 * 获取下一个
 */
- (Song *)next;

/**
 * 从该位置播放
 */
- (void)seekTo:(float)data;

/**
 * 删除音乐
 */
- (void)delete:(NSInteger)index;

/**
 * 删除所有音乐
 */
- (void)deleteAll;
@end

NS_ASSUME_NONNULL_END
