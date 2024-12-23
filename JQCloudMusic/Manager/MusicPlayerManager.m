//
//  MusicPlayerManager.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import <MediaPlayer/MediaPlayer.h>
//图片加载框架
#import <SDWebImage/UIImageView+WebCache.h>
#import "MusicPlayerManager.h"
#import "SuperDatabaseManager.h"
#import "SuperAudioSessionManager.h"
#import "LyricParser.h"

//当前类日志Tag
static NSString * const MusicPlayerManagerTag = @"MusicPlayerManager";

//音乐播放器状态
typedef NS_ENUM(NSInteger, PlayStatus) {
    PlayStatusNone, //未知
    PlayStatusPause, //暂停了
    PlayStatusPlaying, //播放中
    PlayStatusPrepared, //准备中
    PlayStatusCompletion, //当前这一首音乐播放完成
    PlayStatusError //错误
};

@interface MusicPlayerManager ()
/// 播放状态
@property(nonatomic, assign) PlayStatus status;


/// 播放器
@property(nonatomic, strong) AVPlayer *player;

/// 定时器返回的对象
@property(nonatomic, strong) id playTimeObserve;

/// 上一次保存播放进度时间
@property(nonatomic, assign) NSTimeInterval lastSaveProgressTime;


@end

@implementation MusicPlayerManager
/// 获取单例对象
+(instancetype)shared{
    static MusicPlayerManager *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init{
    if (self=[super init]) {
        self.player = [[AVPlayer alloc] init];
        
        //默认状态
        self.status = PlayStatusNone;
    }
    return self;
}

- (void)play:(NSString *)uri data:(Song *)data{
    //设置音频会话
    [SuperAudioSessionManager requestAudioFocus];
    
    //更改播放状态
    _status = PlayStatusPlaying;
    
    //保存音乐对象
    self.data = data;
    
    NSURL *url=nil;
    if ([uri hasPrefix:@"http"]) {
        //网络地址
        url=[NSURL URLWithString:uri];
    } else {
        //本地地址
        url=[NSURL fileURLWithPath:uri];
    }
    
    //创建一个播放Item
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    //替换掉原来的播放Item
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    //播放
    [self.player play];
    
    //设置监听器
    //因为监听器是针对PlayerItem的
    //所以说播放了音乐在这里设置
    [self initListeners];
    
    //回调代理
    if (self.delegate) {
        [self.delegate onPlaying:_data];
    }
    
    //启动进度分发定时器
    [self startPublishProgress];
    
    [self prepareLyric];
}

-(void)prepareLyric{
    //歌词处理
    //真实项目可能会
    //将歌词这个部分拆分到其他组件中
    if (_data.parsedLyric) {
        //解析好了
        [self onLyricReady];
    } else if(_data.lyric) {
        //有歌词，但是没有解析
        [self parseLyric];
    }else{
        //没有歌词，并且不是本地音乐才请求

        //真实项目中可以会缓存歌词
        //获取歌词数据
        [[DefaultRepository shared] songDetailWithId:_data.id success:^(BaseResponse * _Nonnull baseResponse, id  _Nonnull d) {
            //请求成功
            Song *data=d;
            self.data.style=data.style;
            self.data.lyric=data.lyric;
            
            [self parseLyric];
        }];
    }
}

-(void)parseLyric{
    if ([StringUtil isNotBlank:self.data.lyric]) {
        //有歌词
        
        //在这里解析的好处是
        //外面不用管，直接使用
        self.data.parsedLyric = [LyricParser parse:self.data.style data:self.data.lyric];
    }
    
    //通知歌词准备好了
    [self onLyricReady];
}

-(void)onLyricReady{
    if (self.delegate) {
        [self.delegate onLyricReady:_data];
    }
}

-(void)initListeners{
    //KVO方式监听播放状态
    //KVC:Key-Value Coding,另一种获取对象字段的值，类似字典
    //KVO:Key-Value Observing,建立在KVC基础上，能够观察一个字段值的改变
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //监听音乐缓冲状态
    [self.player.currentItem addObserver:self
                              forKeyPath:@"loadedTimeRanges"  options:NSKeyValueObservingOptionNew
                                 context:nil];
    
    //播放结束事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onComplete:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
}

/// 播放完毕了回调
- (void)onComplete:(NSNotification *)notification {
    self.complete(_data);
}

/// 移除监听器
-(void)removeListeners{
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //判断监听的字段
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
                case AVPlayerStatusReadyToPlay:
            {
                //准备播放完成了
                //音乐的总时间
                self.data.duration = CMTimeGetSeconds(self.player.currentItem.asset.duration);
                
                LogDebugTag(MusicPlayerManagerTag, @"observeValue status ReadyToPlay duration:%f",self.data.duration);
                                
                //回调代理
                if (self.delegate) {
                    [self.delegate onPrepared:_data];
                }
                
                //更新媒体控制中心信息
//                [self updateMediaInfo];
                
            }
                break;
                case AVPlayerStatusFailed:
            {
                //播放失败了
                _status = PlayStatusError;
                
                LogDebugTag(MusicPlayerManagerTag, @"observeValue status play error");
            }
                break;
                
            default:{
                //未知状态
                LogDebugTag(MusicPlayerManagerTag, @"observeValue status unknown");
                _status = PlayStatusNone;
            }
                break;
        }
        
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        
        NSLog(@"music play manager loadedTimeRanges:%f",self.data.duration);
        
        //计算缓冲百分比例
        //        NSTimeInterval scale = totalLoadTime/duration;
        
        //更新缓冲进度条
        //        self.loadTimeProgress.progress = scale;
        
//        [self updateMediaInfo];
    }
}



- (BOOL)isPlaying{
    return _status == PlayStatusPlaying;
}

- (void)pause{
    //更改状态
    _status = PlayStatusPause;
    
    //暂停
    [self.player pause];
    
    //移除监听器
    [self removeListeners];

//    //回调代理
    if (self.delegate) {
        [self.delegate onPaused:_data];
    }

    //停止进度分发定时器
    [self stopPublishProgress];
}

- (void)resume{
    //设置音频会话
    [SuperAudioSessionManager requestAudioFocus];
    
    //更改播放状态
    _status = PlayStatusPlaying;
    
    //播放
    [self.player play];
    
    //设置监听器
    [self initListeners];
    
//    //回调代理
    if (self.delegate) {
        [self.delegate onPlaying:_data];
    }
    
    //启动进度分发定时器
    [self startPublishProgress];
    
//    [self prepareLyric];
}

- (void)startPublishProgress{
    //判断是否启动了
    if (_playTimeObserve) {
        //已经启动了
        return;
    }
    
    @weakify(self);
                
    //1/60秒，就是16毫秒
    self.playTimeObserve=[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        
        //当前播放的时间
        self.data.progress = CMTimeGetSeconds(time);
        
        //判断是否有代理
        if (!self.delegate) {
            //没有回调
            //停止定时器
            [self stopPublishProgress];
            return;
        }
        
        //回调代理
        [self.delegate onProgress:self.data];
        
        //保存播放进度，目的是进程杀死后，继续上次播放
        //当然可以监听应用退出在保存
        
        //获取当前时间0秒后的时间，就是当前
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];

        NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];
        NSTimeInterval d=currentTimeMillis - self.lastSaveProgressTime;
        //        NSLog(@"current time:%f last time:%f result:%f",currentTimeMillis,self.lastTime,d);
        if (d > SAVE_PROGRESS_TIME_INTERVAL) {
            //间隔大于2秒才保存，这样做是避免频繁操作
            //具体的存储时间，存储间隔根据业务需求来更改
//            [PreferenceUtil setLastSongProgress:self.data.progress];
            [[SuperDatabaseManager shared] saveSong:self.data];

            self.lastSaveProgressTime = currentTimeMillis;
        }
    }];
}

- (void)stopPublishProgress{
    if (self.playTimeObserve) {
        [self.player removeTimeObserver:self.playTimeObserve];
        self.playTimeObserve=nil;
    }
    
}

- (void)seekTo:(float)data{
    [self.player seekToTime:CMTimeMake(data, 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)setDelegate:(id<MusicPlayerManagerDelegate>)delegate{
    _delegate = delegate;
    if (_delegate) {
        //有代理
        
        //判断是否有音乐在播放
        if ([self isPlaying]) {
            //有音乐在播放
            
            //启动定时器
            [self startPublishProgress];
        }
    } else {
        //没有代理
        
        //停止定时器
        [self stopPublishProgress];
    }
}

#pragma mark - 媒体中心

/// 更新系统媒体控制中心信息
/// 不需要更新进度到控制中心
/// 他那边会自动倒计时
/// 这部分可以重构到公共类，因为像播放视频也可以更新到系统媒体中心
-(void)updateMediaInfo{
    //下载图片,这部分应该封装，因为其他界面也用到了
    SDWebImageManager *manager =[SDWebImageManager sharedManager];
    
    NSURL *url= [NSURL URLWithString:[ResourceUtil resourceUri:self.data.icon]];
    
    [manager loadImageWithURL:url options:SDWebImageProgressiveLoad progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //进度，这里用不到
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        NSLog(@"load song image success");
        if (image!=NULL) {
            [self setMediaInfo:image];
        }
    }];
}

- (void)setMediaInfo:(UIImage *)image{
    //初始化一个可变字典
    NSMutableDictionary *songInfo=[[NSMutableDictionary alloc] init];

    //初始化一个封面
    MPMediaItemArtwork *albumArt=[[MPMediaItemArtwork alloc] initWithBoundsSize:image.size requestHandler:^UIImage * _Nonnull(CGSize size) {
        return image;
    }];

    //设置封面
    [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];

    //歌曲名称
    [songInfo setObject:self.data.title forKey:MPMediaItemPropertyTitle];

    //歌手
    [songInfo setObject:self.data.singer.nickname forKey:MPMediaItemPropertyArtist];

    //专辑名
    [songInfo setObject:@"这是专辑名" forKey:MPMediaItemPropertyAlbumTitle];

    //流派，服务器没返回这样的数据
    //    [songInfo setObject:@"流派" forKey:MPMediaItemPropertyGenre];

    //设置总时长
    [songInfo setObject:[NSString stringWithFormat:@"%f",self.data.duration] forKey:MPMediaItemPropertyPlaybackDuration];

    //设置到系统
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}

@end
