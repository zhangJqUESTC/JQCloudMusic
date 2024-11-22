//
//  RecordPageView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/19.
//

#import "RecordPageView.h"
#import "MusicListManager.h"
#import "MusicPlayerManager.h"
#import "RecordCell.h"

@implementation RecordPageView

- (instancetype)init{
    self=[super init];
    [self initViews];
    return self;
}

-(void)initViews{
    _playing=YES;
    
    self.collectionView=[ViewFactoryUtil pageCollectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    //注册黑胶唱片cell
    [self.collectionView registerClass:[RecordCell class] forCellWithReuseIdentifier:Cell];
    
    //黑胶唱片指针
    self.thumbView = [UIImageView new];
    self.thumbView.myWidth = 92;
    self.thumbView.myHeight=138;
    
    //30:指针中心到图片宽度一半的距离
    self.thumbView.centerXPos.equalTo(self.centerXPos).offset(30);
    self.thumbView.image = R.image.recordThumb;
    self.thumbView.clipsToBounds=YES;
    [self addSubview:self.thumbView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //根据黑胶唱片指针图片计算
    //锚点为0.181，0.120
    [self.thumbView setViewAnchorPoint:CGPointMake(0.181, 0.12)];
    
    [self refreshStatus];
    
    NSLog(@"RecordPageView layoutSubviews %f",self.frame.size.height);
}

- (void)setIsReadly:(BOOL)isReadly{
    _isReadly=isReadly;
    [self.collectionView reloadData];
}

-(void)setProgress:(float)progress{
    if (!_playing) {
        return;
    }
    
    //旋转黑胶唱片
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self getCurrentIndex] inSection:0];
    RecordCell *cell = (RecordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell rotate];
}

/// 获取当前位置的index
-(NSInteger)getCurrentIndex{
    return self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
}

- (void)setPlaying:(BOOL)playing{
    if (_playing == playing) {
        return;
    }

    _playing=playing;
    [self refreshStatus];
}

-(void)refreshStatus{
    if (_playing) {
        //黑胶唱片指针默认状态（播放状态）
        [UIView animateWithDuration:0.5 animations:^{
            self.thumbView.transform = CGAffineTransformIdentity;
        }];
    }else{
        //黑胶唱片指针旋转-25度（暂停状态）
        [UIView animateWithDuration:0.5 animations:^{
            self.thumbView.transform = CGAffineTransformMakeRotation(-0.4363323);
        }];
    }
}

-(void)scrollPosition:(NSIndexPath *)data{
    //延迟后选中当前音乐
    //因为前面执行可能是删除Cell操作
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:data atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}

#pragma mark - CollectionView数据源
/// 有多少个
/// @param collectionView collectionView description
/// @param section section description
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.isReadly ? [[[MusicListManager shared] getDatum] count] : 0;
//    return [[[MusicListManager shared] getDatum] count];
}

/// 返回cell
/// @param collectionView collectionView description
/// @param indexPath indexPath description
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Song *data = [[MusicListManager shared] getDatum][indexPath.row];
    
    RecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    
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
    LogDebug(@"CollectionView height %f",collectionView.frame.size.height);
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
     
}

/// 开始拖拽时调用
/// @param scrollView scrollView description
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.willBeginDragging) {
        self.willBeginDragging();
    }
}

/// 滚动结束（惯性滚动）
/// @param scrollView scrollView description
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.didEndScoll) {
        self.didEndScoll();
    }
}
@end
