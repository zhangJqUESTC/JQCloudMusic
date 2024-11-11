//
//  SimplePlayerController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "SimplePlayerController.h"

//当前类日志Tag
static NSString * const SimplePlayerControllerTag = @"SimplePlayerController";

@interface SimplePlayerController () <MusicPlayerManagerDelegate>
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

/// 歌词控件
//@property(nonatomic, strong) LyricListView *lyricView;
@end

@implementation SimplePlayerController

- (void)initViews{
    [super initViews];
    
    [self initTableViewSafeArea];
    self.tableView.weight = 1;
    
    //歌词控件
//    _lyricView = [LyricListView new];
////    _lyricView.delegate=self;
//    _lyricView.weight = 1;
//    _lyricView.myWidth = MyLayoutSize.fill;
//    _lyricView.myHeight = MyLayoutSize.wrap;
//    _lyricView.backgroundColor = [UIColor black32];
//    [self.container addSubview:_lyricView];
    
    //进度容器
    MyLinearLayout *progressContainer = [ViewFactoryUtil orientationContainer];
    progressContainer.gravity = MyGravity_Vert_Center;
    progressContainer.subviewSpace = PADDING_MEDDLE;
    progressContainer.padding = UIEdgeInsetsMake(PADDING_MEDDLE, PADDING_OUTER, PADDING_MEDDLE, PADDING_OUTER);
    [self.container addSubview:progressContainer];
    
    _startView = [UILabel new];
    _startView.myWidth = MyLayoutSize.wrap;
    _startView.myHeight = MyLayoutSize.wrap;
    _startView.text = @"00:00";
    [progressContainer addSubview:_startView];
    
    _progressView = [UISlider new];
    _progressView.myWidth = MyLayoutSize.wrap;
    _progressView.myHeight = MyLayoutSize.wrap;
    
    //占用剩余控件
    _progressView.weight = 1;
    _progressView.value = 0;
    [progressContainer addSubview:_progressView];
    
    _endView = [UILabel new];
    _endView.myWidth = MyLayoutSize.wrap;
    _endView.myHeight = MyLayoutSize.wrap;
    _endView.text = @"00:00";
    [progressContainer addSubview:_endView];
    
    //按钮容器
    MyLinearLayout *controlContainer = [ViewFactoryUtil orientationContainer];
    controlContainer.gravity = MyGravity_Vert_Center | MyGravity_Horz_Stretch;
    controlContainer.padding = UIEdgeInsetsMake(PADDING_MEDDLE, PADDING_OUTER, PADDING_MEDDLE, PADDING_OUTER);
    [self.container addSubview:controlContainer];
    
    QMUIButton *buttonView = [QMUIButton new];
//    buttonView.myWidth = MyLayoutSize.wrap;
    buttonView.myHeight = MyLayoutSize.wrap;
    [buttonView setTitle:@"上一曲" forState:UIControlStateNormal];
    [buttonView addTarget:self action:@selector(onPreviousClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlContainer addSubview:buttonView];
    
    _playButtonView = [QMUIButton new];
//    buttonView.myWidth = MyLayoutSize.wrap;
    _playButtonView.myHeight = MyLayoutSize.wrap;
    [_playButtonView setTitle:@"播放" forState:UIControlStateNormal];
    [_playButtonView addTarget:self action:@selector(onPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlContainer addSubview:_playButtonView];
    
    buttonView = [QMUIButton new];
//    buttonView.myWidth = MyLayoutSize.wrap;
    buttonView.myHeight = MyLayoutSize.wrap;
    [buttonView setTitle:@"下一曲" forState:UIControlStateNormal];
    [buttonView addTarget:self action:@selector(onNextClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlContainer addSubview:buttonView];
    
    _loopModelButtonView = [QMUIButton new];
//    buttonView.myWidth = MyLayoutSize.wrap;
    _loopModelButtonView.myHeight = MyLayoutSize.wrap;
    [_loopModelButtonView setTitle:@"列表循环" forState:UIControlStateNormal];
    [_loopModelButtonView addTarget:self action:@selector(onLoopModelClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlContainer addSubview:_loopModelButtonView];
}

- (void)initDatum{
    [super initDatum];
//    [[MusicPlayerManager shared] play:@"http://course-music-dev.ixuea.com/assets/Yesterday.mp3" data:[Song new]];
    
    [self initPlayData];
    
    //显示循环模式
    [self showLoopModel];
    
    //解析歌词
//    Lyric *result = [LyricParser parse:VALUE0 data:LYRIC_LRC];
//    NSLog(@"SimplePlayerController parse lrc %@",result.datum);
//
//    //KSC歌词解析
//    result = [LyricParser parse:VALUE10 data:LYRIC_KSC];
//    NSLog(@"SimplePlayerController parse ksc %@",result.datum);
}

- (void)initListeners{
    [super initListeners];
    //监听应用进入前台了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //监听应用进入后台了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //进度条拖拽监听
    [self.progressView addTarget:self action:@selector(onProgressChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressView addTarget:self action:@selector(onProgressTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.progressView addTarget:self action:@selector(onProgressTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addTarget:self action:@selector(onProgressTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
}

/// 进度条拖拽回调
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


#pragma mark 点击事件的回调
- (void)onPreviousClick:(UIButton *)sender{
    [[MusicListManager shared] play: [[MusicListManager shared] previous]];
}

- (void)onPlayClick:(UIButton *)sender{
    [self playOrPause];
}

- (void)onNextClick:(UIButton *)sender{
    [[MusicListManager shared] play: [[MusicListManager shared] next]];
}

- (void)onLoopModelClick:(UIButton *)sender{
    //更改循环模式
    [[MusicListManager shared] changeLoopModel];

    //显示循环模式
    [self showLoopModel];
}

/// 显示循环模式
-(void)showLoopModel{
    //获取当前循环模式
    MusicPlayRepeatModel model = [[MusicListManager shared] getLoopModel];
    
    switch (model) {
        case MusicPlayRepeatModelList:
            [_loopModelButtonView setTitle:@"列表循环" forState:UIControlStateNormal];
            break;
        case MusicPlayRepeatModelRandom:
            [_loopModelButtonView setTitle:@"随机循环" forState:UIControlStateNormal];
            break;
        default:
            [_loopModelButtonView setTitle:@"单曲循环" forState:UIControlStateNormal];
            break;
    }
}

#pragma mark 监听事件的回调
/// 进入前台了
-(void)onEnterForeground:(NSNotification *)data{
    LogDebugTag(SimplePlayerControllerTag, @"onEnterForeground");

    //显示播放数据
    [self initPlayData];//再调用的目的是：当在后台时，有外部事件的发生，导致播放状态改变，所以，需要init

    [self setMusicPlayerDelegate];
    
}

/// 进入后台了
-(void)onEnterBackground:(NSNotification *)data{
    LogDebugTag(SimplePlayerControllerTag, @"onEnterBackground");
    
    [self removeMusicPlayerDelegate];
    
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


/// 播放或暂停
-(void)playOrPause{
    if ([[MusicPlayerManager shared] isPlaying]) {
        [[MusicListManager shared] pause];
    } else {
        [[MusicListManager shared] resume];
    }
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
    
    //选中当前播放的音乐
    [self scrollPosition];
//    
//    //显示歌词数据
//    [self showLyricData];
}

/// 选中当前播放的音乐
-(void)scrollPosition{
    //获取当前音乐在播放列表中的索引
    Song *data = [[MusicListManager shared] getData];
    
    NSUInteger index = [[[MusicListManager shared] getDatum] indexOfObject:data];
    
    if (index != -1) {
        //创建indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        //延迟后选中当前音乐
        //因为前面执行可能是删除Cell操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //选中
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
         });
    }
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
    [_playButtonView setTitle:@"暂停" forState:UIControlStateNormal];
}

/// 显示播放状态
-(void)showPlayStatus{
    [_playButtonView setTitle:@"播放" forState:UIControlStateNormal];
}

/// 显示初始化数据
-(void)showInitData{
    //获取当前播放的音乐
   Song *data = [MusicPlayerManager shared].data;

   //显示标题
    [self setTitle:data.title];
}

/// 显示音乐时长
-(void)showDuration{
    float duration = [MusicPlayerManager shared].data.duration;
    
    if (duration > 0) {
        _endView.text = [SuperDateUtil second2MinuteSecond:duration];
        _progressView.maximumValue = duration;
    }
}

#pragma mark delegate 方法
/// 播放器准备完毕了
/// 可以获取到音乐总时长
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

# pragma mark progress
-(void)showProgress{
    if (self.isTouchProgress) {
        return;
    }
    
    float progress = [MusicPlayerManager shared].data.progress;
    
    if (progress > 0) {
        _startView.text = [SuperDateUtil second2MinuteSecond:progress];
        _progressView.value = progress;
    }
    
    //显示歌词进度
//    [_lyricView setProgress:progress];
}

/// 歌词数据准备好了
- (void)onLyricReady:(Song *)data{
//    [self showLyricData];
}

#pragma mark - 列表数据源

/// 有多少个
/// @param tableView tableView description
/// @param section section description
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[MusicListManager shared] getDatum] count];
}


/// 返回当前位置的cell
/// 相当于Android中RecyclerView Adapter的onCreateViewHolder
/// @param tableView tableView description
/// @param indexPath indexPath description
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Song *data= [[MusicListManager shared] getDatum][indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if (!cell) {
        //也可以在这里创建，也可以在前面注册
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Cell];
    }
    
    cell.textLabel.text = data.title;
    
    return cell;
}

/// cell点击
/// @param tableView tableView description
/// @param indexPath indexPath description
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前点击的这首音乐
    Song *data= [[MusicListManager shared] getDatum][indexPath.row];
    
    //播放
    [[MusicListManager shared] play:data];
}

+ (void)start:(UINavigationController *)controller{
    SimplePlayerController *newController=[[SimplePlayerController alloc] init];
    [controller pushViewController:newController animated:YES];
}
@end
