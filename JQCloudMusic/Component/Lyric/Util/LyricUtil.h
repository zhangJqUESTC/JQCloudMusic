//
//  LyricUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import <Foundation/Foundation.h>
#import "Lyric.h"

NS_ASSUME_NONNULL_BEGIN

@interface LyricUtil : NSObject
/// 计算当前播放时间是那一行歌词
/// @param lyric 歌词对象
/// @param progress 播放时间，单位秒
+(NSInteger)getLineNumber:(Lyric *)lyric progress:(float)progress;

/// 获取当前播放时间对应该行第几个字
/// @param line <#line description#>
/// @param progress <#progress description#>
+ (NSInteger)getWordIndex:(LyricLine *)line progress:(float)progress;

/// 获取当前字播放的时间
/// @param line <#line description#>
/// @param progress <#progress description#>
+ (NSInteger)getWordPlayedTime:(LyricLine *)line progress:(float)progress;
@end

NS_ASSUME_NONNULL_END
