//
//  Video.h
//  JQCloudMusic
//  视频模型
//  Created by zhangjq on 2024/10/15.
//

#import "SuperCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface Video : SuperCommon
/// 标题
@property(nonatomic, strong) NSString *title;

/// 视频地址
/// 和图片地址一样
/// 都是相对地址
@property(nonatomic, strong) NSString *uri;

/// 封面地址
@property(nonatomic, strong) NSString *icon;

/// 视频时长
/// 单位：秒
@property(nonatomic, assign) int duration;

/// 视频宽
@property(nonatomic, assign) int width;

/// 视频高
@property(nonatomic, assign) int height;

/// 点击数
@property(nonatomic, assign) int clicksCount;


/// 评论数
@property(nonatomic, assign) int commentsCount;

/// 谁发布了这个视频
//@property(nonatomic, strong) User *user;

/// 是否是竖屏视频
-(BOOL)isPortrait;

@end

NS_ASSUME_NONNULL_END
