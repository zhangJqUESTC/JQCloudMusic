//
//  LyricListView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "LyricListView.h"
#import "LyricCell.h"
#import "LyricUtil.h"
#import "MusicListManager.h"

//当前类日志Tag
static NSString * const LyricListViewTag = @"LyricListView";

@interface LyricListView ()
/**
 * 歌词填充多个占位数据
 */
@property(nonatomic, assign) int lyricPlaceholderSize;

/**
 * 当前时间歌词行数
 */
@property(nonatomic, assign) NSInteger lyricLineNumber;

/// 是否已经调用了reloadData
@property(nonatomic, assign) BOOL isReloadData;

/// 歌词拖拽效果容器
@property(nonatomic, strong) MyLinearLayout *lyricDragContainer;

/// 拖拽位置歌词时间
@property(nonatomic, strong) UILabel *timeView;

/// 是否在拖拽状态
@property(nonatomic, assign) BOOL isDrag;


/// 滚动时，当前这行歌词
@property(nonatomic, strong) NSObject *scrollSelectedLyricLine;

@end

@implementation LyricListView

- (instancetype)init{
    self=[super init];
    
    self.datum = [NSMutableArray array];
    
    [self initViews];
    
    return self;
}

- (void)initViews{
    //设置约束
    self.myWidth = MyLayoutSize.fill;
    self.myHeight = MyLayoutSize.fill;
    
    //tableView
    self.tableView = [ViewFactoryUtil tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    //注册歌词cell
    [self.tableView registerClass:[LyricCell class] forCellReuseIdentifier:Cell];
    
    //创建一个水平方向容器
    _lyricDragContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    _lyricDragContainer.visibility = MyVisibility_Gone;
    _lyricDragContainer.myHorzMargin = PADDING_OUTER;
    _lyricDragContainer.myWidth = MyLayoutSize.fill;
    _lyricDragContainer.myHeight = MyLayoutSize.wrap;

    //控件之间间距
    _lyricDragContainer.subviewSpace = PADDING_MEDDLE;

    //内容水平居中
    _lyricDragContainer.gravity = MyGravity_Vert_Center;

    //居中
    _lyricDragContainer.centerYPos.equalTo(@0);
    [self addSubview:_lyricDragContainer];

    //播放按钮
    QMUIButton *playView = [QMUIButton new];
    playView.myWidth = 15;
    playView.myHeight = 15;
    [playView setImage:[R.image.play withTintColor] forState:UIControlStateNormal];
    playView.tintColor = [UIColor colorLightWhite];
    //图片完全显示到控件里面
    playView.contentMode = UIViewContentModeScaleAspectFit;
    [playView addTarget:self action:@selector(onPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    [_lyricDragContainer addSubview:playView];

    //分割线
    UIView *dividerView = [ViewFactoryUtil smallDivider];
    dividerView.weight=1;
    dividerView.backgroundColor = [UIColor colorLightWhite];
    [_lyricDragContainer addSubview:dividerView];

    //时间
    _timeView = [UILabel new];
    _timeView.myWidth = MyLayoutSize.wrap;
    _timeView.myHeight = MyLayoutSize.wrap;
    _timeView.text = @"00:00";
    _timeView.textColor = [UIColor colorLightWhite];
    [_lyricDragContainer addSubview:_timeView];
}

- (void)setData:(Lyric *)data{
    _data=data;
    
    if (_lyricPlaceholderSize > 0) {
        //已经计算了填充数量
        [self next];
    }
}

- (void)next{
    //清空原来的歌词
    [_datum removeAllObjects];

    if (_data) {
        //添加占位数据
        [self addLyricFillData];
        [_datum addObjectsFromArray:_data.datum];

        //添加占位数据
        [self addLyricFillData];
    }

    _isReloadData=YES;
    [_tableView reloadData];
}

/// 添加歌词占位数据
/// 添加的目的是让第一行歌词也能显示到控件垂直方向中心
-(void)addLyricFillData {
    for (int i=0; i<_lyricPlaceholderSize; i++) {
        [_datum addObject:@"fill"];
    }
}

//每16ms就会被调用
- (void)setProgress:(float)progress{
    if(!_isReloadData && _lyricPlaceholderSize > 0){
        //还没有加载数据
        
        //所以这里加载数据
        [self next];
    }
    
    if (_data && _datum.count>0) {
        if (_isDrag) {
           //正在拖拽歌词
           //就直接返回
           return;
        }
        
        //获取当前时间对应的歌词索引
        NSInteger newLineNumber = [LyricUtil getLineNumber:_data progress:progress] + _lyricPlaceholderSize;

        if (newLineNumber != _lyricLineNumber) {
           //滚动到当前行
           [self scrollPosition:newLineNumber];

           _lyricLineNumber = newLineNumber;
        }
        
        //如果是精确到字歌曲
       //还需要将时间分发到item中
       //因为要持续绘制
       if (_data.isAccurate) {
           NSObject *object = _datum[_lyricLineNumber];
           if ([object isKindOfClass:[LyricLine class]]) {
               //只有是歌词行才处理

               //获取当前时间是该行的第几个字
               NSInteger lyricCurrentWordIndex=[LyricUtil getWordIndex:object progress:progress];

               //获取当前时间改字
               //已经播放的时间
               NSInteger wordPlayedTime=[LyricUtil getWordPlayedTime:object progress:progress];

               //获取cell
               LyricCell *cell= [self getCell:self.lyricLineNumber];

               if (cell) {
                   //有可能获取不到当前位置的Cell
                   //因为上面使用了滚动动画
                   //如果不使用滚动动画效果不太好

                   //将当前时间对应的字索引设置到控件
                   [cell.lineView setLyricCurrentWordIndex:lyricCurrentWordIndex];

                   //设置当前字已经播放的时间
                   [cell.lineView setWordPlayedTime:wordPlayedTime];

                   //标记需要绘制
                   [cell.lineView setNeedsDisplay];
               }

           }
       }
    }
}

/// 根据位置Cell
/// @param position position description
- (LyricCell *)getCell:(NSInteger)position{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
    
    LyricCell *cell= [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

/// 滚动到当前歌词行
/// @param lineNumber lineNumber description
-(void)scrollPosition:(NSInteger)lineNumber {
    NSIndexPath *indexPaht = [NSIndexPath indexPathForItem:lineNumber inSection:0];
    [_tableView selectRowAtIndexPath:indexPaht animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

/// 这个方法会调用多次计算，最后一次才是最准确的值
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_lyricPlaceholderSize > 0) {
        return;
    }

    _lyricPlaceholderSize = (int)ceilf(CGRectGetHeight(self.tableView.frame) / 2.0 / 44);
}

#pragma mark - 滚动相关

/// 开始拖拽时调用
/// @param scrollView scrollView description
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LogDebugTag(LyricListViewTag, @"scrollViewWillBeginDragging");
    [self showDragView];
}

/// 拖拽结束
/// @param scrollView scrollView description
/// @param decelerate decelerate description
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"lyric view scrollViewDidEndDragging:%d",decelerate);

    if (!decelerate) {
        //如果不需要减速，就延时后，显示歌词
        [self prepareScrollLyricView];
    }
}

/// 滚动结束（惯性滚动）
/// @param scrollView scrollView description
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"lyric view scrollViewDidEndDecelerating");
    //如果需要减速，在这里延时后，显示歌词
    [self prepareScrollLyricView];
}

/// 滑动中
/// @param scrollView scrollView description
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isDrag) {
        //只有手动拖拽的时候才处理

        CGFloat offsetY  = scrollView.contentOffset.y;
        
        //根据滚动距离计算出index
        NSInteger index = (offsetY+self.tableView.frame.size.height/2)/44;
        
        
        NSLog(@"lyric view scrollViewDidScroll %f %ld",offsetY,index);

        //获取歌词对象
        NSObject *lyric = nil;
        if (index < 0) {
            //如果计算出的index小于0
            //就默认第一个歌词对象
            lyric = self.datum.firstObject;
        }else if (index > self.datum.count - 1) {
            //大于最后一个歌词对象（包含填充数据）
            //就是最后一行数据
            lyric = self.datum.lastObject;
        }else {
            //如果在列表范围内
            //就直接去对应位置的数据
            lyric = self.datum[index];
        }

        //设置滚动时间

        //判断是否是填充数据
        if ([lyric isKindOfClass:[NSString class]]) {
            //填充数据
            [self.timeView setText:@""];
        }else{
            //真实歌词数据
            //保存到一个字段上
            self.scrollSelectedLyricLine=lyric;

            LyricLine *line=(LyricLine *)lyric;
            [self.timeView setText:[SuperDateUtil second2MinuteSecond:line.startTime/1000]];
        }
    }

}

//显示拖拽效果
- (void)showDragView{
    if ([self isLyricEmpty]) {
        //没有歌词不能拖拽
        return;
    }

    self.isDrag=YES;

    self.lyricDragContainer.visibility = MyVisibility_Visible;
}

/// 是否没有歌词数据
- (BOOL)isLyricEmpty{
    return _datum.count == 0;
}

- (void)prepareScrollLyricView{
    //取消原来的任务
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showScrollLyricView) object:nil];

    //4秒后继续滚动歌词
    [self performSelector:@selector(showScrollLyricView) withObject:nil afterDelay:4.0];
}

//显示歌词滚动View
- (void)showScrollLyricView{
    self.isDrag=NO;
    
    //取消原来的任务
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showScrollLyricView) object:nil];

    self.lyricDragContainer.visibility = MyVisibility_Gone;
}

#pragma mark - 列表数据源
/// 有多少个
/// @param tableView tableView description
/// @param section section description
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datum.count;
}

/// 返回当前位置的cell
/// @param tableView tableView description
/// @param indexPath indexPath description
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取cell
    LyricCell *cell=[tableView dequeueReusableCellWithIdentifier:Cell forIndexPath:indexPath];
    
    //设置Tag
    cell.tag = indexPath.row;
    
    //取出数据
    NSObject *data = _datum[indexPath.row];
    
    //绑定数据
    [cell bind:data accurate:_data.isAccurate];
    
    //返回cell
    return cell;
}

- (void)onPlayClick:(QMUIButton *)sender{
    if (self.scrollSelectedLyricLine!=nil) {
        LyricLine *line=(LyricLine *)self.scrollSelectedLyricLine;
        
        //回调回来是毫秒，要转为秒
        [[MusicListManager shared] seekTo:line.startTime/1000];

        //马上显示歌词滚动
        [self showScrollLyricView];
    }
}

@end
