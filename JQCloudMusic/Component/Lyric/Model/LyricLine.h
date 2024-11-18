//
//  LyricLine.h
//  JQCloudMusic
//  一行歌词模型
//  Created by zhangjq on 2024/11/18.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

//单位都是毫秒
@interface LyricLine : SuperBase
/// 整行歌词
@property(nonatomic, strong) NSString *data;

/// 开始时间
@property(nonatomic, assign) int startTime;

/**
 * 每一个字
 */
@property(nonatomic, strong) NSMutableArray *words;

/**
 * 每一个字对应的时间
 */
@property(nonatomic, strong) NSMutableArray *wordDurations;

/**
 * 结束时间
 */
@property(nonatomic, assign) int endTime;

@end

NS_ASSUME_NONNULL_END
