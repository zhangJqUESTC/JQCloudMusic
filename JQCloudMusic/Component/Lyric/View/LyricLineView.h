//
//  LyricLineView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import <UIKit/UIKit.h>

#import "LyricLine.h"

NS_ASSUME_NONNULL_BEGIN

//对齐方式
typedef NS_ENUM(NSUInteger, LyricLineGravity) {
    LyricLineGravityLeft, //左对齐
    LyricLineGravityCenter //水平居中
};

@interface LyricLineView : UIView
/**
 * 当前歌词行
 */
@property(nonatomic, strong) LyricLine *data;

/**
 * 是否是精确到字歌词
 */
@property(nonatomic, assign) BOOL accurate;

/**
 * 是否选中
 */
@property(nonatomic, assign) BOOL lineSelected;

/// 文字大小
@property(nonatomic, assign) CGFloat lyricTextSize;

/// 歌词颜色
@property(nonatomic, strong) UIColor *lyricTextColor;

/// 高亮歌词颜色
@property(nonatomic, strong) UIColor *lyricSelectedTextColor;

/**
 * 对齐方式
 */
@property(nonatomic, assign) LyricLineGravity gravity;

/**
 * 当前行歌词已经唱过的宽度，也就是歌词高亮的宽度
 */
@property(nonatomic, assign) float lineLyricPlayedWidth;

/**
 * 当前字，已经播放的时间
 */
@property(nonatomic, assign) float wordPlayedTime;

/**
 * 当前播放时间点，在该行的第几个字
 */
@property(nonatomic, assign) NSInteger lyricCurrentWordIndex;

@end

NS_ASSUME_NONNULL_END
