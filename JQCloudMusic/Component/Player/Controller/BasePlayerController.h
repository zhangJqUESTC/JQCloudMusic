//
//  BasePlayerController.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "BaseTitleController.h"
#import "MusicPlayerManager.h"
#import "MusicListManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePlayerController : BaseTitleController
/// 启动播放界面
-(void)startMusicPlayerController;
@end

NS_ASSUME_NONNULL_END
