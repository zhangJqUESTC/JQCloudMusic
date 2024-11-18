//
//  Lyric.h
//  JQCloudMusic
//  歌词
//  Created by zhangjq on 2024/11/18.
//

#import "SuperBase.h"
#import "LyricLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface Lyric : SuperBase
/**
 * 是否是精确到字的歌词
 */
@property(nonatomic, assign) BOOL isAccurate;

/**
 * 所有的歌词
 */
@property(nonatomic, strong) NSMutableArray *datum;
@end

NS_ASSUME_NONNULL_END
