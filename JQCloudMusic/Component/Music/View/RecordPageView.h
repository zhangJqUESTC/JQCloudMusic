//
//  RecordPageView.h
//  JQCloudMusic
//  黑胶唱片左右滚动View
//  Created by zhangjq on 2024/11/19.
//

#import <MyLayout/MyLayout.h>

///开始滚动block
typedef void(^RecordWillBeginDragging)(void);

///结束滚动block
typedef void(^RecordDidEndScoll)(void);

NS_ASSUME_NONNULL_BEGIN

@interface RecordPageView : MyRelativeLayout <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/// 黑胶唱片左右滚动view
@property(nonatomic, strong) UICollectionView *collectionView;

/// 黑胶唱片指针
@property(nonatomic, strong) UIImageView *thumbView;

@property(nonatomic, assign) BOOL isReadly;

/// 开始滚动block
@property (nonatomic, strong, nullable) RecordWillBeginDragging willBeginDragging;

/// 结束滚动block
@property (nonatomic, strong, nullable) RecordDidEndScoll didEndScoll;

/// 是否是播放状态
@property (nonatomic, assign) BOOL playing;

-(void)setProgress:(float)progress;

/// 获取当前位置的index
-(NSInteger)getCurrentIndex;

-(void)scrollPosition:(NSIndexPath *)data;
@end

NS_ASSUME_NONNULL_END
