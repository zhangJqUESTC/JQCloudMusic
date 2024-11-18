//
//  SuperAudioSessionManager.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "SuperAudioSessionManager.h"

@implementation SuperAudioSessionManager
+ (void)requestAudioFocus{
    //获取到音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];

    //设置category
    //可以简单理解为：category就是预定好的一些模式
    //playback:可以后台播放；独占；音量可以控制音量
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];

    //激活音频会话
    [session setActive:YES error:nil];
}
@end
