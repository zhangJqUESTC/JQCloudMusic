//
//  MusicPlayerController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/19.
//

#import "MusicPlayerController.h"
#import "LyricListView.h"
#import "MusicPlayerManager.h"
#import "MusicListManager.h"
#import "RecordPageView.h"
#import "PlayListView.h"
#import <GKCover/GKCover.h>
#import "MusicListChangedEvent.h"

//当前类日志Tag
static NSString * const MusicPlayerControllerTag = @"MusicPlayerController";

@interface MusicPlayerController () <MusicPlayerManagerDelegate>
//背景
@property(nonatomic, strong) UIImageView *backgroundImageView;

//背景模糊
@property(nonatomic, strong) UIVisualEffectView *backgroundVisual;

/// 黑胶唱片
@property(nonatomic, strong) RecordPageView *recordView;

/// 歌词
@property(nonatomic, strong) LyricListView *lyricView;

/// 点赞按钮
@property(nonatomic, strong) QMUIButton *likeButton;

/// 下载按钮
@property(nonatomic, strong) QMUIButton *downloadButton;

/// 开始时间
@property(nonatomic, strong) UILabel *startView;

/// 拖拽进度控件
@property(nonatomic, strong) UISlider *progressView;

/// 结束时间
@property(nonatomic, strong) UILabel *endView;

/// 播放按钮
@property(nonatomic, strong) QMUIButton *playButtonView;

/// 循环模式按钮
@property(nonatomic, strong) QMUIButton *loopModelButtonView;

/// 是否按下了进度条
@property(nonatomic, assign) BOOL isTouchProgress;

/// 当前音乐下载对象
//@property (nonatomic, strong) DownloadInfo *downloadInfo;
@end

@implementation MusicPlayerController

- (void)initViews{
    [super initViews];
    
    //添加背景图片控件
    _backgroundImageView = [UIImageView new];
    
    //默认隐藏
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.image = R.image.defaultCover;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    //背景模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _backgroundVisual = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_backgroundImageView addSubview:_backgroundVisual];
    
    [self initLinearLayoutSafeArea];
    
    [self setToolbarLight];
    
    //顶部容器，主要用来显示黑胶唱片，歌词等信息
    [self initTopContainer];
    
    //小控制容器
    [self initSmallControlContainer];
    
    //进度容器
    [self initProgressContainer];
    
    //控制容器
    [self initControlContainer];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _backgroundImageView.frame = self.view.bounds;
    _backgroundVisual.frame = self.view.bounds;
}

- (void)initDatum{
    [super initDatum];
    
    [self initPlayData];
    
    //显示循环模式
    [self showLoopModel];
}

- (void)initListeners{
    [super initListeners];
    @weakify(self);
    //监听应用进入前台了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //监听应用进入后台了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //进度条拖拽监听
    [self.progressView addTarget:self action:@selector(onProgressChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressView addTarget:self action:@selector(onProgressTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.progressView addTarget:self action:@selector(onProgressTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addTarget:self action:@selector(onProgressTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    //黑胶唱片点击
    [self.recordView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRecordViewClick)]];
    
    //歌词View点击
    [self.lyricView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLyricViewClick)]];
    
        //注册播放列表改变了监听事件
        [QTSubMain(self,MusicListChangedEvent) next:^(MusicListChangedEvent *event) {
            @strongify(self);
            [self onMusicListChanged];
        }];
}

/// 显示播放数据，在应用进入前台和第一次显示界面时调用
-(void)initPlayData{
    //显示初始化数据
    [self showInitData];
    
    //显示音乐时长
    [self showDuration];
    
    //显示播放状态
    [self showMusicPlayStatus];
    
    //显示播放进度
    [self showProgress];
    
    //显示歌词数据
    [self showLyricData];
}

/// 显示初始化数据
-(void)showInitData{
    //获取当前播放的音乐
    Song *data = [[MusicListManager shared] getData];
    
    //显示标题
    [self setTitle:data.title];
    
}

/// 显示音乐时长
-(void)showDuration{
    float duration = [[MusicListManager shared] getData].duration;
    
    if (duration > 0) {
        _endView.text = [SuperDateUtil second2MinuteSecond:duration];
        _progressView.maximumValue = duration;
    }
}

/// 显示歌词数据
-(void)showLyricData{
    _lyricView.data = [[MusicListManager shared] getData].parsedLyric;
}

/// 显示何种状态
-(void)showMusicPlayStatus{
    if ([[MusicPlayerManager shared] isPlaying]) {
        [self showPauseStatus];
    } else {
        [self showPlayStatus];
    }
}

/// 显示暂停状态
-(void)showPauseStatus{
    [_playButtonView setImage:[R.image.pause withTintColor] forState:UIControlStateNormal];
    [self setRecordPlaying:YES];
}

/// 显示播放状态
-(void)showPlayStatus{
    [_playButtonView setImage:[R.image.playCircleBlack withTintColor] forState:UIControlStateNormal];
    [self setRecordPlaying:NO];
}

-(void)showProgress{
    if (self.isTouchProgress) {
        return;
    }
    
    float progress = [[MusicListManager shared] getData].progress;
    
    if (progress > 0) {
        _startView.text = [SuperDateUtil second2MinuteSecond:progress];
        _progressView.value = progress;
    }
    if (self.recordView.visibility == MyVisibility_Visible) {
        [self.recordView setProgress:progress];
    }
    //显示歌词进度
    [_lyricView setProgress:progress];
}

#pragma mark 监听事件的回调
/// 进入前台了
-(void)onEnterForeground:(NSNotification *)data{
    LogDebugTag(MusicPlayerControllerTag, @"onEnterForeground");
    
    //显示播放数据
    [self initPlayData];//再调用的目的是：当在后台时，有外部事件的发生，导致播放状态改变，所以，需要init
    
    [self setMusicPlayerDelegate];
    
}

/// 进入后台了
-(void)onEnterBackground:(NSNotification *)data{
    LogDebugTag(MusicPlayerControllerTag, @"onEnterBackground");
    
    [self removeMusicPlayerDelegate];
    
}

/// 播放列表改变了
-(void)onMusicListChanged{
    NSArray *datum = [[MusicListManager shared] getDatum];
    if (datum.count>0) {
        [self.recordView.collectionView reloadData];
    }else{
        [self finish];
    }
}

#pragma mark 视图可见与否时改变delegate，以提高性能
/// 视图即将可见方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setMusicPlayerDelegate];
}

/// 视图即将消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeMusicPlayerDelegate];
}

-(void)setMusicPlayerDelegate{
    //设置播放代理
    [MusicPlayerManager shared].delegate = self;
}

-(void)removeMusicPlayerDelegate{
    //取消播放代理
    [MusicPlayerManager shared].delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.recordView.isReadly=YES;
    
    //选中当前播放的音乐
    [self scrollPosition];
}

#pragma mark - //顶部容器，主要用来显示黑胶唱片，歌词等信息
-(void)initTopContainer{
    @weakify(self);
    
    MyRelativeLayout *container = [MyRelativeLayout new];
    container.myWidth = MyLayoutSize.fill;
    container.myHeight = MyLayoutSize.fill;
    
    //高度为剩余所有高度
    container.weight = 1;
    [self.container addSubview:container];
    
    //歌词控件
    self.lyricView=[LyricListView new];
    self.lyricView.myWidth = MyLayoutSize.fill;
    self.lyricView.myHeight = MyLayoutSize.fill;
    //默认隐藏
    self.lyricView.visibility = MyVisibility_Gone;
    [container addSubview:self.lyricView];
    
    //黑胶唱片控件
    self.recordView=[RecordPageView new];
    self.recordView.myWidth = MyLayoutSize.fill;
    self.recordView.myHeight = MyLayoutSize.fill;
    [self.recordView setWillBeginDragging:^{
        @strongify(self);
        [self setRecordPlaying:NO];
    }];
    
    [self.recordView setDidEndScoll:^{
        @strongify(self);
        [self recordDidEndScorll];
    }];
    [container addSubview:self.recordView];
}

-(void)setRecordPlaying:(BOOL)data{
    [self.recordView setPlaying:data];
}

-(void)recordDidEndScorll{
    //判断黑胶唱片位置对应的音乐是否和现在播放的是一首
    NSInteger index=[self.recordView getCurrentIndex];
    Song *song = [[MusicListManager shared] getDatum][index];
    if ([[[MusicListManager shared] getData].id isEqualToString:song.id]) {
        //一样
        
        //判断播放状态
        if ([[MusicPlayerManager shared] isPlaying]) {
            [self setRecordPlaying:YES];
        }
    } else {
        //不一样
        [self setRecordPlaying:YES];
        
        //播放当前位置的音乐
        [[MusicListManager shared] play:song];
    }
}

/// 选中当前播放的音乐
-(void)scrollPosition{
    //获取当前音乐在播放列表中的索引
    Song *data = [[MusicListManager shared] getData];
    
    NSUInteger index = [[[MusicListManager shared] getDatum] indexOfObject:data];
    
    if (index != -1) {
        //创建indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        //选中
        [self.recordView scrollPosition:indexPath];
    }
}

#pragma mark - 小控制容器
-(void)initSmallControlContainer{
    MyLinearLayout *container = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    container.myWidth = MyLayoutSize.fill;
    container.myHeight = MyLayoutSize.wrap;
    [self.container addSubview:container];
    
    //点赞按钮
    self.likeButton = [ViewFactoryUtil buttonWithImage:[R.image.like withTintColor]];
    self.likeButton.tintColor = [UIColor colorLightWhite];
    self.likeButton.myWidth = MyLayoutSize.wrap;
    self.likeButton.myHeight = 60;
    self.likeButton.weight = 1;
    [container addSubview:self.likeButton];
    
    //下载按钮
    self.downloadButton = [ViewFactoryUtil buttonWithImage:[R.image.download withTintColor]];
    self.downloadButton.tintColor = [UIColor colorLightWhite];
    self.downloadButton.myWidth = MyLayoutSize.wrap;
    self.downloadButton.myHeight = 60;
    self.downloadButton.weight = 1;
    [self.downloadButton addTarget:self action:@selector(onDownloadClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.downloadButton];
    
    //EQ按钮
    QMUIButton *eqButton = [ViewFactoryUtil buttonWithImage:[R.image.eq withTintColor]];
    eqButton.tintColor = [UIColor colorLightWhite];
    eqButton.myWidth = MyLayoutSize.wrap;
    eqButton.myHeight = 60;
    eqButton.weight = 1;
    [container addSubview:eqButton];
    
    //评论按钮
    QMUIButton *commentButton = [ViewFactoryUtil buttonWithImage:[R.image.comments withTintColor]];
    commentButton.tintColor = [UIColor colorLightWhite];
    commentButton.myWidth = MyLayoutSize.wrap;
    commentButton.myHeight = 60;
    commentButton.weight = 1;
    [container addSubview:commentButton];
    
    //更多按钮
    QMUIButton *moreButton = [ViewFactoryUtil buttonWithImage:[R.image.ellipsisVertical withTintColor]];
    moreButton.tintColor = [UIColor colorLightWhite];
    moreButton.myWidth = MyLayoutSize.wrap;
    moreButton.myHeight = 60;
    moreButton.weight = 1;
    [container addSubview:moreButton];
}

#pragma mark - 进度容器
-(void)initProgressContainer{
    MyLinearLayout *container = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    container.myWidth = MyLayoutSize.fill;
    container.myHeight = MyLayoutSize.wrap;
    container.gravity = MyGravity_Vert_Center;
    container.subviewSpace = 10;
    container.padding = UIEdgeInsetsMake(0, PADDING_OUTER, 0, PADDING_OUTER);
    [self.container addSubview:container];
    
    _startView = [UILabel new];
    _startView.myWidth = MyLayoutSize.wrap;
    _startView.myHeight = MyLayoutSize.wrap;
    _startView.text = @"00:00";
    _startView.textColor = [UIColor colorLightWhite];
    [container addSubview:_startView];
    
    _progressView = [UISlider new];
    _progressView.myWidth = MyLayoutSize.wrap;
    _progressView.myHeight = MyLayoutSize.wrap;
    
    //进度条
    //设置进度条颜色
    _progressView.minimumTrackTintColor = [UIColor colorPrimary];
    
    //设置拖动点颜色
    _progressView.thumbTintColor = [UIColor colorPrimary];
    
    //占用剩余控件
    _progressView.weight = 1;
    _progressView.value = 0;
    [container addSubview:_progressView];
    
    _endView = [UILabel new];
    _endView.myWidth = MyLayoutSize.wrap;
    _endView.myHeight = MyLayoutSize.wrap;
    _endView.textColor = [UIColor colorLightWhite];
    _endView.text = @"00:00";
    [container addSubview:_endView];
}

#pragma mark - 控制容器
-(void)initControlContainer{
    MyLinearLayout *container = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    container.myWidth = MyLayoutSize.fill;
    container.myHeight = MyLayoutSize.wrap;
    [self.container addSubview:container];
    
    //循环模式按钮
    self.loopModelButtonView = [ViewFactoryUtil buttonWithImage:[R.image.repeatList withTintColor]];
    self.loopModelButtonView.tintColor = [UIColor colorLightWhite];
    self.loopModelButtonView.myWidth = MyLayoutSize.wrap;
    self.loopModelButtonView.heightSize.equalTo(self.loopModelButtonView.widthSize);
    self.loopModelButtonView.weight = 1;
    self.loopModelButtonView.contentEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    [self.loopModelButtonView addTarget:self action:@selector(onLoopModelClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.loopModelButtonView];
    
    //上一曲按钮
    QMUIButton *previousButton = [ViewFactoryUtil buttonWithImage:[R.image.previous withTintColor]];
    previousButton.tintColor = [UIColor colorLightWhite];
    previousButton.myWidth = MyLayoutSize.wrap;
    previousButton.heightSize.equalTo(previousButton.widthSize);
    previousButton.weight = 1;
    previousButton.contentEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    [previousButton addTarget:self action:@selector(onPreviousClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:previousButton];
    
    //播放按钮
    self.playButtonView = [ViewFactoryUtil buttonWithImage:[R.image.playCircleBlack withTintColor]];
    self.playButtonView.tintColor = [UIColor colorLightWhite];
    self.playButtonView.myWidth = MyLayoutSize.wrap;
    self.playButtonView.heightSize.equalTo(self.playButtonView.widthSize);
    self.playButtonView.weight = 1;
    self.playButtonView.contentEdgeInsets = UIEdgeInsetsMake(PADDING_MEDDLE, PADDING_MEDDLE, PADDING_MEDDLE, PADDING_MEDDLE);
    [self.playButtonView addTarget:self action:@selector(onPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.playButtonView];
    
    //下一曲按钮
    QMUIButton *nextButton = [ViewFactoryUtil buttonWithImage:[R.image.next withTintColor]];
    nextButton.tintColor = [UIColor colorLightWhite];
    nextButton.myWidth = MyLayoutSize.wrap;
    nextButton.heightSize.equalTo(nextButton.widthSize);
    nextButton.weight = 1;
    nextButton.contentEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    [nextButton addTarget:self action:@selector(onNextClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:nextButton];
    
    //播放列表按钮
    QMUIButton *listButton = [ViewFactoryUtil buttonWithImage:[R.image.list withTintColor]];
    listButton.tintColor = [UIColor colorLightWhite];
    listButton.myWidth = MyLayoutSize.wrap;
    listButton.heightSize.equalTo(listButton.widthSize);
    listButton.weight = 1;
    listButton.contentEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    [listButton addTarget:self action:@selector(onListClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:listButton];
}

/// 显示循环模式
-(void)showLoopModel{
    //获取当前循环模式
    MusicPlayRepeatModel model = [[MusicListManager shared] getLoopModel];
    
    switch (model) {
        case MusicPlayRepeatModelList:
            [_loopModelButtonView setImage:[R.image.repeatList withTintColor] forState:UIControlStateNormal];
            break;
        case MusicPlayRepeatModelRandom:
            [_loopModelButtonView setImage:[R.image.repeatRandom withTintColor] forState:UIControlStateNormal];
            break;
        default:
            [_loopModelButtonView setImage:[R.image.repeatOne withTintColor] forState:UIControlStateNormal];
            break;
    }
}

#pragma mark 点击事件回调
/// 下载点击
/// @param sender sender description
-(void)onDownloadClick:(UIButton *)sender{
    
}

-(void)onLoopModelClick:(UIButton *)sender{
    //更改循环模式
    [[MusicListManager shared] changeLoopModel];
    
    //显示循环模式
    [self showLoopModel];
    
}

-(void)onPreviousClick:(UIButton *)sender{
    [[MusicListManager shared] play: [[MusicListManager shared] previous]];
}

-(void)onPlayClick:(UIButton *)sender{
    [self playOrPause];
}

/// 播放或暂停
-(void)playOrPause{
    if ([[MusicPlayerManager shared] isPlaying]) {
        [[MusicListManager shared] pause];
    } else {
        [[MusicListManager shared] resume];
    }
}

-(void)onNextClick:(UIButton *)sender{
    [[MusicListManager shared] play: [[MusicListManager shared] next]];
}

-(void)onRecordViewClick{
    self.lyricView.visibility           = MyVisibility_Visible;
    
    [UIView animateWithDuration:0.5 animations:^{
        //动画里面不用使用weak
        self.lyricView.alpha            = 1.0;
        self.recordView.alpha            = 0.0;
    }completion:^(BOOL finished) {
        self.recordView.visibility = MyVisibility_Invisible;
        [self.lyricView setProgress:[[MusicListManager shared] getData].progress];
    }];
}
-(void)onLyricViewClick{
    @weakify(self);
    self.recordView.visibility = MyVisibility_Visible;
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        self.recordView.alpha = 1.0;
        self.lyricView.alpha = 0.0;
    } completion:^(BOOL finished) {
        @weakify(self);
        self.lyricView.visibility = MyVisibility_Gone;
    }];
}

-(void)onListClick:(UIButton *)sender{
    //创建一个View
    PlayListView *contentView = [PlayListView new];
    contentView.myWidth = SCREEN_WIDTH;
    contentView.myHeight = self.view.frame.size.height/1.5;
    
    //设置尺寸
    //contentView.gk_size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
    
    [GKCover coverFrom:self.view contentView:contentView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:NO];
}


#pragma mark 进度条拖拽回调
/// @param sender sender description
-(void)onProgressChanged:(UISlider *)sender{
    //将拖拽进度显示到界面
    //用户就很方便的知道自己拖拽到什么位置
    _startView.text = [SuperDateUtil second2MinuteSecond:sender.value];

    //音乐切换到拖拽位置播放
    [[MusicListManager shared] seekTo:sender.value];
}

/// 进度条按下
/// @param sender sender description
-(void)onProgressTouchDown:(UISlider *)sender{
    self.isTouchProgress=YES;
}

/// 进度条抬起
/// @param sender sender description
-(void)onProgressTouchUp:(UISlider *)sender{
    self.isTouchProgress=NO;
}

#pragma mark MusicPlayerManagerDelegate 方法
/// 播放器准备完毕了
/// 可以获取到音乐总时长，切换音乐时会回调这个方法
- (void)onPrepared:(Song *)data{
    //显示初始化数据
    [self showInitData];

    //显示时长
    [self showDuration];
    
    [self showPauseStatus];
//
    //选中当前音乐
    [self scrollPosition];
}

/// 暂停了
- (void)onPaused:(Song *)data{
    [self showPlayStatus];
}

/// 正在播放
- (void)onPlaying:(Song *)data{
    [self showPauseStatus];
}

/// 进度回调
- (void)onProgress:(Song *)data{
    [self showProgress];
}

/// 歌词数据准备好了
- (void)onLyricReady:(Song *)data{
    [self showLyricData];
}

@end
