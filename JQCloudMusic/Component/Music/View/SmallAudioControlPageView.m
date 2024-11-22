//
//  SmallAudioControlPageView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

#import "SmallAudioControlPageView.h"
#import "MusicListManager.h"
#import "SongSmallCell.h"
#import "LyricUtil.h"
#import "MusicPlayerManager.h"

@implementation SmallAudioControlPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.paddingTrailing = 8;
    //分割线
    [self addSubview:[ViewFactoryUtil smallDivider]];
    
    //水平容器
    MyLinearLayout *orientationContainer = [ViewFactoryUtil orientationContainer];
    orientationContainer.gravity = MyGravity_Vert_Center;
    [self addSubview:orientationContainer];
    
    //左右滚动控件
    self.collectionView=[ViewFactoryUtil pageCollectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.weight=1;
    [orientationContainer addSubview:self.collectionView];
    
    //注册cell
    [self.collectionView registerClass:[SongSmallCell class] forCellWithReuseIdentifier:Cell];
    
    //播放按钮
    self.playButtonView = [ViewFactoryUtil buttonWithImage:[R.image.playCircleBlack withTintColor]];
    self.playButtonView.tintColor = [UIColor colorOnSurface];
    self.playButtonView.myWidth = 50;
    self.playButtonView.myHeight = 50;
    self.playButtonView.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    [orientationContainer addSubview:self.playButtonView];
    
    //播放列表按钮
    _listButton = [ViewFactoryUtil buttonWithImage:[R.image.list withTintColor]];
    _listButton.tintColor = [UIColor colorOnSurface];
    _listButton.myWidth = 50;
    _listButton.myHeight = 50;
    _listButton.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    [orientationContainer addSubview:_listButton];
    
    //进度条
    self.progressView = [SuperHorizontalProgressView new];
    self.progressView .myWidth = MyLayoutSize.fill;
    
    self.progressView .myHeight = 1;
    
    self.progressView.backgroundColor = [UIColor colorDivider];
    
    //设置进度条颜色
    self.progressView.progressTintColor = [UIColor colorPrimary];
    [self addSubview:self.progressView];
    
}


-(void)scrollPosition:(NSIndexPath *)data{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:data atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
     });
}

-(void)setPlaying:(BOOL)data{
    UIImage *result = data ? [R.image.pause withTintColor] : [R.image.playCircleBlack withTintColor];
    [_playButtonView setImage:result forState:UIControlStateNormal];
}

-(void)setProgress:(float)progress{
    if (_isDrag) {
        //如果在拖拽，就不更新歌词，否则会显示到其他cell
        return;
    }
    
    _progressView.value = progress;
    
    if (_data && _data.datum.count>0) {
       //获取当前时间对应的歌词索引
       NSInteger newLineNumber = [LyricUtil getLineNumber:_data progress:progress];

       LyricLine *object = _data.datum[newLineNumber];

       //获取cell
       SongSmallCell *cell= [self getCurrentCell];

       if (cell) {
           cell.lineView.data = object;
           cell.lineView.accurate = _data.isAccurate;

           //如果是精确到字歌曲
           //还需要将时间分发到item中
           //因为要持续绘制
           if (_data.isAccurate) {
               //获取当前时间是该行的第几个字
               NSInteger lyricCurrentWordIndex=[LyricUtil getWordIndex:object progress:progress];

               //获取当前时间改字
               //已经播放的时间
               NSInteger wordPlayedTime=[LyricUtil getWordPlayedTime:object progress:progress];


               //有可能获取不到当前位置的Cell
               //因为上面使用了滚动动画
               //如果不使用滚动动画效果不太好

               //将当前时间对应的字索引设置到控件
               [cell.lineView setLyricCurrentWordIndex:lyricCurrentWordIndex];

               //设置当前字已经播放的时间
               [cell.lineView setWordPlayedTime:wordPlayedTime];

           }

           //标记需要绘制
           [cell.lineView setNeedsDisplay];
       }
   }
}

/// 获取当前位置的index
-(NSInteger)getCurrentIndex{
    return self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
}

/// 根据位置Cell position description
- (SongSmallCell *)getCurrentCell{
    NSInteger position = [self getCurrentIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
    
    SongSmallCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

#pragma mark - CollectionView数据源

/// 有多少个
/// @param collectionView collectionView description
/// @param section section description
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[MusicListManager shared] getDatum] count];
}

/// 返回cell
/// @param collectionView collectionView description
/// @param indexPath indexPath description
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Song *data = [[MusicListManager shared] getDatum][indexPath.row];
    
    SongSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    
    [cell bind:data];
    
    return cell;
}

#pragma mark - CollectionView布局代理

/// 返回CollectionView里面的Cell到CollectionView的间距
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/// 返回每个Cell的行间距
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

/// 返回每个Cell的列间距
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //让Cell和CollectionView一样大
    return CGSizeMake(collectionView.frame.size.width, 50);
}

#pragma mark - 列表滚动

/// 开始拖拽时调用
/// @param scrollView scrollView description
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDrag=YES;
}

/// 滚动结束（惯性滚动）
/// @param scrollView scrollView description
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isDrag=NO;
    
    //判断黑胶唱片位置对应的音乐是否和现在播放的是一首
    NSInteger index=[self getCurrentIndex];
    Song *song = [[MusicListManager shared] getDatum][index];
    if ([[[MusicListManager shared] getData].id isEqualToString:song.id]) {
        //一样
    } else {
        //不一样

        //播放当前位置的音乐
        [[MusicListManager shared] play:song];
    }
}
@end
