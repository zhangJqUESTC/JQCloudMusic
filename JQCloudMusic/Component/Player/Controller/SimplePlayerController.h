//
//  SimplePlayerController.h
//  JQCloudMusic
//  简单的音乐播放实现
//  主要测试音乐播放相关逻辑
//  因为黑胶唱片界面的逻辑比较复杂
//  如果在和播放相关逻辑混一起，不好实现
//  所有我们可以先使用一个简单的播放器
//  从而把播放器相关逻辑实现完成
//  然后在对接的黑胶唱片
//  就相对来说简单一点
//  Created by zhangjq on 2024/11/10.
//

#import "BasePlayerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimplePlayerController : BasePlayerController
+ (void)start:(UINavigationController *)controller;
@end

NS_ASSUME_NONNULL_END
