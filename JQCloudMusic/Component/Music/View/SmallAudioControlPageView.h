//
//  SmallAudioControlPageView.h
//  JQCloudMusic
//  小的音频播放控制view
//  就是在主界面底部显示的那个小控制条，可以左右滚动切换音乐
//  Created by zhangjq on 2024/11/12.
//

#import <MyLayout/MyLayout.h>
#import "SuperHorizontalProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallAudioControlPageView : MyLinearLayout
/// 黑胶唱片左右滚动view
@property(nonatomic, strong) UICollectionView *collectionView;

/// 播放按钮
@property(nonatomic, strong) QMUIButton *playButtonView;

/// 播放列表按钮
@property(nonatomic, strong) QMUIButton *listButton;

/// 进度条
@property(nonatomic, strong) SuperHorizontalProgressView *progressView;

/// 是否在拖拽状态
@property(nonatomic, assign) BOOL isDrag;

/// 歌词对象
//@property(nonatomic,strong) Lyric *data;

/// 选中当前音乐
-(void)scrollPosition:(NSIndexPath *)data;

-(void)setProgress:(float)progress;

/// 设置是否是播放状态
/// @param data <#data description#>
-(void)setPlaying:(BOOL)data;
@end

NS_ASSUME_NONNULL_END
