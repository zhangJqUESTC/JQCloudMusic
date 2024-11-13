//
//  BaseMainController.m
//  JQCloudMusic
//  首页，几个控制器父类，主要是处理顶部导航栏
//  Created by zhangjq on 2024/10/20.
//

#import "BaseMainController.h"
//侧滑菜单
#import <UIViewController+CWLateralSlide.h>
#import "DrawerController.h"
#import "MusicListChangedEvent.h"
#import "SmallAudioControlPageView.h"
#import "MusicListChangedEvent.h"
#import "ClickEvent.h"


@interface BaseMainController () <MusicPlayerManagerDelegate>

@property (nonatomic, strong)  SmallAudioControlPageView *smallAudioControlPageView;

@property(nonatomic, strong) DrawerController* drawerController;
@end

@implementation BaseMainController

-(void)initViews{
    [super initViews];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"标题"];
    
    //左侧按钮
    [self addLeftImageButton:[R.image.menu withTintColor]];
    //右侧按钮
    [self addRightImageButton:[R.image.mic withTintColor]];
    
    //搜索按钮
    _searchButton = [[QMUIButton alloc] init];
    _searchButton.myWidth = SCREEN_WIDTH-50*2;
    _searchButton.myHeight = 35;
    _searchButton.adjustsTitleTintColorAutomatically = YES;
    _searchButton.titleLabel.font = UIFontMake(TEXT_MEDDLE);
    _searchButton.tintColor =[UIColor black80];
    _searchButton.layer.cornerRadius = 17.5;
    [_searchButton setTitle:R.string.localizable.hintSearchValue forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor black80] forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor colorDivider];
    [_searchButton setImage:[R.image.search withTintColor] forState:UIControlStateNormal];
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.imagePadding = 5; // 相当于之前的 setImageEdgeInsets
        _searchButton.configuration = config;
    _searchButton.imagePosition = QMUIButtonImagePositionLeft;
    [_searchButton addTarget:self action:@selector(onSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addCenterView:_searchButton];
}

- (void)initListeners{
    [super initListeners];
    @weakify(self);
    
    // 注册导航栏手势驱动
    __weak typeof(self)weakSelf = self;
    // 第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf openDrawer];
        }
    }];
    
    //注册播放列表改变了监听事件
    [QTSubMain(self,MusicListChangedEvent) next:^(MusicListChangedEvent *event) {
        @strongify(self);
        [self onMusicListChanged];
    }];
    
    //监听应用进入前台了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
//
//    //消息未读数量改变了通知
//    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onMessageCountChanged) name:ON_MESSAGE_COUNT_CHANGED object:nil];
}

-(void)onLeftClick:(QMUIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    [self openDrawer];
}

-(void)onRightClick:(QMUIButton *)sender{
    
}

-(void)onSearchClick:(QMUIButton *)sender{
    NSLog(@"BaseMainController onSearchClick");
}

#pragma mark - 侧滑

- (void)openDrawer{
    //真实内容滑动到外面
//    [self cw_showDefaultDrawerViewController:self.drawerController];
    
    //侧滑显示到真实内容上面
    [self cw_showDrawerViewController:self.drawerController animationType:CWDrawerAnimationTypeMask configuration:nil];
}

- (void)closeDrawer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 获取侧滑控制器
- (DrawerController *)drawerController{
    if (!_drawerController) {
        _drawerController = [DrawerController new];
    }
    return _drawerController;
}

#pragma mark - 生命周期

/// 进入前台了
-(void)onEnterForeground:(NSNotification *)data{

    //显示播放数据
    [self initPlayData];
    
    [self setMusicPlayerDelegate];
}

#pragma mark - 迷你播放器
/// 视图即将可见方法
/// @param animated animated description
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self onMusicListChanged];
    
    if (self.smallAudioControlPageView.superview==nil) {
        return;
    }
    
    //显示播放数据
    [self initPlayData];
    
    [self setMusicPlayerDelegate];
}

/// 界面已经显示了
/// @param animated animated description
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //第一次获取消息数
//    [self onMessageCountChanged];
}

-(void)setMusicPlayerDelegate{
    //设置播放代理
    [MusicPlayerManager shared].delegate = self;
}

-(void)removeMusicPlayerDelegate{
    //取消播放代理
    [MusicPlayerManager shared].delegate = nil;
}

/// 显示播放数据
-(void)initPlayData{
    //选中当前播放的音乐
    [self scrollPosition];
    
    //显示歌词数据
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
        
        //选中
        [self.smallAudioControlPageView scrollPosition:indexPath];
    }
}

/// 播放列表改变了
-(void)onMusicListChanged{
    NSArray *datum = [[MusicListManager shared] getDatum];
    if (datum.count>0) {
        //添加迷你播放控制器
        [self.superFooterContentContainer addSubview:self.smallAudioControlPageView];

        //选中当前播放的音乐
        [self scrollPosition];

        //显示音乐时长
        [self showDuration];

        //显示播放进度
        [self showProgress];

        //显示播放状态
        [self showMusicPlayStatus];
    }else{
        //隐藏迷你控制器
        [self.smallAudioControlPageView removeFromSuperview];
    }
}

/// 返回迷你播放控制器
- (SmallAudioControlPageView *)smallAudioControlPageView{
    if (!_smallAudioControlPageView) {
        _smallAudioControlPageView = [SmallAudioControlPageView new];
        _smallAudioControlPageView.backgroundColor = [UIColor colorLightWhite];
        _smallAudioControlPageView.myWidth = MyLayoutSize.fill;
        _smallAudioControlPageView.myHeight = 50;
        
        //点击
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSmallAudioControlClick:)];
        [_smallAudioControlPageView addGestureRecognizer:tapGestureRecognizer];
        
        //播放按钮点击，可以通过代理，block回调，但因为这些知识点已经讲解了，所以就直接设置
        [_smallAudioControlPageView.playButtonView addTarget:self action:@selector(onPlayClick:) forControlEvents:UIControlEventTouchUpInside];

        //播放列表点击
        [_smallAudioControlPageView.listButton addTarget:self action:@selector(onListClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smallAudioControlPageView;
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

-(void)onListClick:(UIButton *)sender{
    ClickEvent *event = [[ClickEvent alloc] init];
    event.style = StylePlayList;
    [QTEventBus.shared dispatch:event];
}

/// 显示音乐时长
-(void)showDuration{
    float duration = [[MusicListManager shared] getData].duration;
    if (duration > 0) {
        _smallAudioControlPageView.progressView.maximumValue = duration;
    }
}

/// 显示播放进度
-(void)showProgress{
    float progress = [[MusicListManager shared] getData].progress;
    float duration = [[MusicListManager shared] getData].duration;
    if (duration > 0) {
        [_smallAudioControlPageView setProgress:progress/duration];
    }else{
        [_smallAudioControlPageView setProgress:0];
    }
    
}

/// 显示播放状态
-(void)showMusicPlayStatus{
    if ([[MusicPlayerManager shared] isPlaying]) {
        [self showPauseStatus];
    } else {
        [self showPlayStatus];
    }
}

/// 显示暂停状态
-(void)showPauseStatus{
    [_smallAudioControlPageView setPlaying:YES];
}

/// 显示播放状态
-(void)showPlayStatus{
    [_smallAudioControlPageView setPlaying:NO];
}

/// 迷你播放控制器点击
/// @param gestureRecognizer gestureRecognizer description
-(void)onSmallAudioControlClick:(UITapGestureRecognizer *)gestureRecognizer{
    [self startMusicPlayerController];
}

#pragma mark - 播放管理器代理
/// 播放器准备完毕了
/// 可以获取到音乐总时长
- (void)onPrepared:(Song *)data{

    //显示时长
    [self showDuration];

    //选中当前音乐
    [self scrollPosition];
}

/// 暂停了
/// @param data data description
- (void)onPaused:(Song *)data{
    [self showPlayStatus];
}

/// 正在播放
/// @param data data description
- (void)onPlaying:(Song *)data{
    [self showPauseStatus];
}

/// 进度回调
/// @param data data description
- (void)onProgress:(Song *)data{
    [self showProgress];
}

/// 歌词信息改变了
/// @param data data description
- (void)onLyricReady:(Song *)data{
//    [self showLyricData];
}

@end
