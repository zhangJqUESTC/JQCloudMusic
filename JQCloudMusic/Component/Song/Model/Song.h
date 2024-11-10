//
//  Song.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/20.
//

#import "SuperBase.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song : SuperBase
/// 标题
@property (nonatomic, strong) NSString *title;

/// 封面
@property (nonatomic, strong) NSString *icon;

/// 音乐地址
@property (nonatomic, strong) NSString *uri;

/// 点击数
@property (nonatomic, assign) int clicksCount;

/// 评论数
@property (nonatomic, assign) int commentsCount;

/// 歌词类型
@property (nonatomic, assign) int style;

/// 创建该音乐的人
@property (nonatomic, strong) User *user;

/// 歌手
@property (nonatomic, strong) User *singer;

//播放后才有值
/// 总进度
/// 单位：秒
@property (nonatomic, assign) float duration;

/// 播放进度
@property (nonatomic, assign) float progress;

//end 播放后才有值

/// 是否在播放列表
@property (nonatomic, assign) BOOL list;

/// 音乐来源
@property (nonatomic, assign) int source;

/**
 * 本地扫描的音乐路径
 * 也是相对位置
 *
 * 在线的音乐下载后路径在下载对象那边
 */
@property (nonatomic, strong) NSString *path;

/**
 * 已经解析后的歌词
 */
//@property (nonatomic, strong) Lyric *parsedLyric;

/**
 * 歌词内容
 */
@property (nonatomic, strong) NSString *lyric;

/**
 * 歌手Id
 * <p>
 * 在sqlite，mysql这样的数据库中
 * 字段名建议用下划线
 * 而不是驼峰命名
 *
 * 用来将歌手对象拆分到多个字段，方便在一张表存储，和查询
 */
@property (nonatomic, strong) NSString *singerId;

/**
 * 歌手名称
 */
@property (nonatomic, strong) NSString *singerNickname;

/**
 * 歌手头像
 * 可选值
 */
@property (nonatomic, strong) NSString *singerIcon;

-(void)convertLocal;
-(void)localConvert;
@end

NS_ASSUME_NONNULL_END
