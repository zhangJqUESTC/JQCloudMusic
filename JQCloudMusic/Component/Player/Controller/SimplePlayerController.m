//
//  SimplePlayerController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "SimplePlayerController.h"
#import "LyricParser.h"
#import "LyricListView.h"


static NSString * const LYRIC_LRC =  @"[ti:爱的代价]\n[ar:李宗盛]\n[al:爱的代价]\n[00:00.50]爱的代价\n[00:02.50]演唱：李宗盛\n[00:06.50]\n[00:16.70]还记得年少时的梦吗\n[00:21.43]像朵永远不调零的花\n[00:25.23]陪我经过那风吹雨打\n[00:28.59]看世事无常\n[00:30.57]看沧桑变化\n[00:33.31]那些为爱所付出的代价\n[00:37.10]是永远都难忘的啊\n[00:41.10]所有真心的痴心的话\n[00:44.57]永在我心中虽然已没有他\n[00:51.46]走吧 走吧 人总要学着自己长大\n[00:59.53]走吧 走吧 人生难免经历苦痛挣扎\n[01:07.19]走吧 走吧 为自己的心找一个家\n[01:15.41]也曾伤心流泪\n[01:17.55]也曾黯然心碎\n[01:19.57]这是爱的代价\n[01:22.57]\n[01:40.67]也许我偶尔还是会想他\n[01:45.28]偶尔难免会惦记着他\n[01:49.10]就当他是个老朋友吧\n[01:52.60]也让我心疼也让我牵挂\n[01:57.37]只是我心中不再有火花\n[02:01.21]让往事都随风去吧\n[02:05.10]所有真心的痴心的话\n[02:08.53]仍在我心中\n[02:10.39]虽然已没有他\n[02:15.26]走吧 走吧 人总要学着自己长大\n[02:23.14]走吧 走吧 人生难免经历苦痛挣扎\n[02:31.26]走吧 走吧 为自己的心找一个家\n[02:39.22]也曾伤心流泪\n[02:41.54]也曾黯然心碎\n[02:43.60]这是爱的代价\n[02:46.44]\n[03:22.77]走吧 走吧 人总要学着自己长大\n[03:31.16]走吧 走吧 人生难免经历苦痛挣扎\n[03:39.08]走吧 走吧 为自己的心找一个家\n[03:47.12]也曾伤心流泪\n[03:49.41]也曾黯然心碎\n[03:51.58]这是爱的代价\n";


static NSString * const LYRIC_KSC =  @"karaoke := CreateKaraokeObject;\nkaraoke.rows := 2;\nkaraoke.TimeAfterAnimate := 2000;\nkaraoke.TimeBeforeAnimate := 4000;\nkaraoke.clear;\n\nkaraoke.add('00:27.487', '00:32.068', '一时失志不免怨叹', '347,373,1077,320,344,386,638,1096');\nkaraoke.add('00:33.221', '00:38.068', '一时落魄不免胆寒', '282,362,1118,296,317,395,718,1359');\nkaraoke.add('00:38.914', '00:42.164', '那通失去希望', '290,373,348,403,689,1147');\nkaraoke.add('00:42.485', '00:44.530', '每日醉茫茫', '298,346,366,352,683');\nkaraoke.add('00:45.273', '00:49.029', '无魂有体亲像稻草人', '317,364,380,351,326,351,356,389,922');\nkaraoke.add('00:50.281', '00:55.585', '人生可比是海上的波浪', '628,1081,376,326,406,371,375,1045,378,318');\nkaraoke.add('00:56.007', '01:00.934', '有时起有时落', '303,362,1416,658,750,1438');\nkaraoke.add('01:02.020', '01:04.581', '好运歹运', '360,1081,360,760');\nkaraoke.add('01:05.283', '01:09.453', '总嘛要照起来行', '303,338,354,373,710,706,1386');\nkaraoke.add('01:10.979', '01:13.029', '三分天注定', '304,365,353,338,690');\nkaraoke.add('01:13.790', '01:15.950', '七分靠打拼', '356,337,338,421,708');\nkaraoke.add('01:16.339', '01:20.870', '爱拼才会赢', '325,1407,709,660,1430');\nkaraoke.add('01:33.068', '01:37.580', '一时失志不免怨叹', '307,384,1021,363,357,374,677,1029');\nkaraoke.add('01:38.660', '01:43.656', '一时落魄不免胆寒', '381,411,1067,344,375,381,648,1389');\nkaraoke.add('01:44.473', '01:47.471', '那通失去希望', '315,365,340,369,684,925');\nkaraoke.add('01:48.000', '01:50.128', '每日醉茫茫', '338,361,370,370,689');\nkaraoke.add('01:50.862', '01:54.593', '无魂有体亲像稻草人', '330,359,368,376,325,334,352,389,898');\nkaraoke.add('01:55.830', '02:01.185', '人生可比是海上的波浪', '654,1056,416,318,385,416,373,1032,342,363');\nkaraoke.add('02:01.604', '02:06.716', '有时起有时落', '303,330,1432,649,704,1694');\nkaraoke.add('02:07.624', '02:10.165', '好运歹运', '329,1090,369,753');\nkaraoke.add('02:10.829', '02:15.121', '总嘛要照起来行', '313,355,362,389,705,683,1485');\nkaraoke.add('02:16.609', '02:18.621', '三分天注定', '296,363,306,389,658');\nkaraoke.add('02:19.426', '02:21.428', '七分靠打拼', '330,359,336,389,588');\nkaraoke.add('02:21.957', '02:26.457', '爱拼才会赢', '315,1364,664,767,1390');\nkaraoke.add('02:50.072', '02:55.341', '人生可比是海上的波浪', '656,1086,349,326,359,356,364,1095,338,340');\nkaraoke.add('02:55.774', '03:01.248', '有时起有时落', '312,357,1400,670,729,2006');\nkaraoke.add('03:01.787', '03:04.369', '好运歹运', '341,1084,376,781');\nkaraoke.add('03:05.041', '03:09.865', '总嘛要起工来行', '305,332,331,406,751,615,2084');\nkaraoke.add('03:10.754', '03:12.813', '三分天注定', '309,359,361,366,664');\nkaraoke.add('03:13.571', '03:15.596', '七分靠打拼', '320,362,349,352,642');\nkaraoke.add('03:16.106', '03:20.688', '爱拼才会赢', '304,1421,661,706,1490');";

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
@property(nonatomic, strong) LyricListView *lyricView;
@end

@implementation SimplePlayerController

- (void)initViews{
    [super initViews];
    
    [self initTableViewSafeArea];
    self.tableView.weight = 1;
    
    //歌词控件
    _lyricView = [LyricListView new];
//    _lyricView.delegate=self;
    _lyricView.weight = 1;
    _lyricView.myWidth = MyLayoutSize.fill;
    _lyricView.myHeight = MyLayoutSize.wrap;
    _lyricView.backgroundColor = [UIColor black32];
    [self.container addSubview:_lyricView];
    
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
    Lyric *result = [LyricParser parse:VALUE0 data:LYRIC_LRC];
    NSLog(@"SimplePlayerController parse lrc %@",result.datum);

    //KSC歌词解析
    result = [LyricParser parse:VALUE10 data:LYRIC_KSC];
    NSLog(@"SimplePlayerController parse ksc %@",result.datum);
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
    
    //选中当前播放的音乐
    [self scrollPosition];

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
    
    //显示歌词数据
    [self showLyricData];
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
    
    float progress = [[MusicListManager shared] getData].progress;
    
    if (progress > 0) {
        _startView.text = [SuperDateUtil second2MinuteSecond:progress];
        _progressView.value = progress;
    }
    
    //显示歌词进度
    [_lyricView setProgress:progress];
}

/// 歌词数据准备好了
- (void)onLyricReady:(Song *)data{
    [self showLyricData];
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
