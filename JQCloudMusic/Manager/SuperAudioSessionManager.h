//
//  SuperAudioSessionManager.h
//  JQCloudMusic
//  音频管理器，主要处理音频焦点获取，释放，音量调整
//  Created by zhangjq on 2024/11/13.
//

//导入系统媒体
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperAudioSessionManager : NSObject
+(void)requestAudioFocus;
@end

NS_ASSUME_NONNULL_END
