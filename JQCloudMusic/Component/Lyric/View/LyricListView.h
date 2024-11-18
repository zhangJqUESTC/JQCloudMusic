//
//  LyricListView.h
//  JQCloudMusic
//  垂直显示多行歌词
//  Created by zhangjq on 2024/11/18.
//

#import <MyLayout/MyLayout.h>
#import "Lyric.h"

NS_ASSUME_NONNULL_BEGIN

@interface LyricListView : MyRelativeLayout <QMUITableViewDataSource,QMUITableViewDelegate>
/// 歌词对象
@property(nonatomic,strong) Lyric *data;

/// 歌词列表控件
@property(nonatomic,strong) QMUITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datum;

/// 设置进度
/// @param progress data description
-(void)setProgress:(float)progress;
@end

NS_ASSUME_NONNULL_END
