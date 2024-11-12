//
//  MusicListManager.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/11.
//

#import "MusicListManager.h"
#import "MusicPlayerManager.h"
#import "SuperDatabaseManager.h"
#import "DataUtil.h"
#import "MusicListChangedEvent.h"
//当前类日志Tag
static NSString * const MusicListManagerTag = @"MusicListManager";

@interface MusicListManager ()

//列表
@property(nonatomic, strong) NSMutableArray *datum;

//当前音乐对象
@property(nonatomic, strong) Song *data;

//是否播放了
@property(nonatomic, assign) BOOL isPlay;

// 播放管理器
@property(nonatomic, strong) MusicPlayerManager *musicPlayerManager;

//循环模式
//默认列表循环
@property(nonatomic, assign) MusicPlayRepeatModel model;

@end

@implementation MusicListManager
static MusicListManager *sharedInstance = nil;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _datum=[[NSMutableArray alloc] init];
        
        //初始化音乐播放管理器
        self.musicPlayerManager=[MusicPlayerManager shared];
        
        __weak typeof(self)weakSelf = self;
        
        //设置播放完毕回调
        [self.musicPlayerManager setComplete:^(Song * _Nonnull data) {
            
            //判断播放循环模式
            if ([weakSelf getLoopModel] == MusicPlayRepeatModelOne) {
                //单曲循环
                [weakSelf play:weakSelf.data];
            } else {
                //其他模式
                [weakSelf play:[weakSelf next]];
            }
        }];
        
        self.model=MusicPlayRepeatModelList;
        
        [self initPlayList];
    }
    return self;
}

/// 获取单例对象
+(instancetype)shared{
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

-(void)initPlayList{
    [_datum removeAllObjects];

    //查询播放列表
    NSArray *datum=[[SuperDatabaseManager shared] findPlayList];

    if (datum.count > 0) {
        //添加到现在的播放列表
        [_datum addObjectsFromArray:datum];

        //获取最后播放音乐id
        NSString *id = [PreferenceUtil getLastPlaySongId];
        if ([StringUtil isNotBlank:id]) {
            //有最后播放音乐的id

            //在播放列表中找到该音乐
            for (Song *s in _datum) {
                if ([id isEqualToString:s.id]) {
                    _data = s;
                    break;
                }
            }

            if (_data == nil) {
                //表示没找到
                //可能各种原因
                [self defaultPlaySong];
            } else {
                //找到了
            }
        } else {
            //如果没有最后播放音乐奥迪
            //默认就是第一首
            [self defaultPlaySong];
        }
    }

}

-(void)defaultPlaySong{
    _data=_datum[0];
}

/// 设置播放列表
- (void)setDatum:(NSArray *)datum{
    //将原来数据playList标志设置为false
    [DataUtil changePlayListFlag:_datum inList:NO];

    //保存到数据库
    [self saveAll];

    //清空原来的数据
    [_datum removeAllObjects];

    //添加新的数据
    [_datum addObjectsFromArray:datum];

    //更改播放列表标志
    [DataUtil changePlayListFlag:_datum inList:YES];

    //保存到数据库
    [self saveAll];

    [self sendMusicListChanged];
}

/// 保存当前播放列表到数据库
-(void)saveAll{
    [[SuperDatabaseManager shared] saveAllSong:_datum];
}

-(void)sendMusicListChanged{
    MusicListChangedEvent *event = [[MusicListChangedEvent alloc] init];
    [QTEventBus.shared dispatch:event];
}

// 获取播放列表
- (NSArray *)getDatum{
    return _datum;
}

- (void)play:(Song *)data{
    self.data = data;
    
    //标记为播放了
    self.isPlay = YES;
    
    NSString *path;
    
    //查询是否有下载任务
//    DownloadInfo *downloadInfo=[[AppDelegate.shared getDownloadManager] findDownloadInfo:data.id];
//    if (downloadInfo != nil && downloadInfo.status == DownloadStatusCompleted) {
//        //下载完成了
//
//        //播放本地音乐
//        path = [[StorageUtil documentUrl] URLByAppendingPathComponent:downloadInfo.path].path;
//
//        LogDebugTag(MusicListManagerTag, @"MusicListManager play offline:%@ %@",path,data.uri);
//    } else {
//        //播放在线音乐
//        path = [ResourceUtil resourceUri:data.uri];
//
//        LogDebugTag(MusicListManagerTag, @"MusicListManager play online:%@ %@",path,data.uri);
//    }
    path = [ResourceUtil resourceUri:data.uri];
    LogDebugTag(MusicListManagerTag, @"MusicListManager play online:%@ %@",path,data.uri);
    
    [_musicPlayerManager play:path data:data];
    
    //设置最后播放音乐的Id
    [PreferenceUtil setLastPlaySongId:_data.id];
}

// 暂停
- (void)pause{
    LogDebugTag(MusicListManagerTag, @"pause");
    [_musicPlayerManager pause];
}

//继续播放
- (void)resume{
    LogDebugTag(MusicListManagerTag, @"resume");
    if (self.isPlay) {
        //原来已经播放过
        //也就说播放器已经初始化了
        [_musicPlayerManager resume];
    } else {
        //到这里，是应用开启后，第一次点继续播放
        //而这时内部其实还没有准备播放，所以应该调用播放
        [self play:_data];

        //判断是否需要继续播放
        if (_data.progress > 0) {
            //有播放进度

            //就从上一次位置开始播放
            [_musicPlayerManager seekTo:_data.progress];
        }
    }

}

/// 更改循环模式
- (MusicPlayRepeatModel)changeLoopModel{
    //循环模式+1
    _model++;

    //判断循环模式边界
    if (_model > MusicPlayRepeatModelRandom) {
        //如果当前循环模式
        //大于最后一个循环模式
        //就设置为第0个循环模式
        _model = MusicPlayRepeatModelList;
    }
    
    //返回最终的循环模式
    return _model;
}

//获取循环模式
- (MusicPlayRepeatModel)getLoopModel{
    return _model;
}

//获取上一个
- (Song *)previous{
    //音乐索引
    NSUInteger index = 0;

    //判断循环模式
    switch (self.model) {
        case MusicPlayRepeatModelRandom:{
            //随机循环

            //在0~datum.size()中
            //不包含datum.size()
            index = arc4random() % [_datum count];
        }
            break;
        default:{
            //找到当前音乐索引
            index = [_datum indexOfObject:self.data];

            if (index != -1) {
                //找到了

                //如果当前播放是列表第一个
                if (index == 0) {
                    //第一首音乐

                    //那就从最后开始播放
                    index = [_datum count] - 1;
                } else {
                    index--;
                }
            } else {
                //抛出异常
                //因为正常情况下是能找到的
                
            }
        }
            break;
    }

    //获取音乐
    return [_datum objectAtIndex:index];
}

//获取下一个
- (Song *)next{
    if ([_datum count] == 0) {
        //如果没有音乐了
        //直接返回null
        return nil;
    }

    //音乐索引
    NSUInteger index = 0;

    //判断循环模式
    switch (self.model) {
        case MusicPlayRepeatModelRandom:{
            //随机循环

            //在0~datum.size()中
            //不包含datum.size()
            index = arc4random() % [_datum count];
        }
            break;
        default:{
            //找到当前音乐索引
            index = [_datum indexOfObject:self.data];

            if (index != -1) {
                //找到了

                //如果当前播放是列表最后一个
                if (index == [_datum count] - 1) {
                    //最后一首音乐

                    //那就从0开始播放
                    index = 0;
                } else {
                    index++;
                }
            } else {
                //抛出异常
                //因为正常情况下是能找到的
            }
        }
            break;
    }

    //获取音乐
    return [_datum objectAtIndex:index];
}

//从该位置播放
- (void)seekTo:(float)data{
    [_musicPlayerManager seekTo:data];
    
    //如果暂停了就继续播放
    if (![_musicPlayerManager isPlaying]) {
        [self resume];
    }
}


- (Song *)getData{
    return self.data;
}


@end
