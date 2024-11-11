//
//  BasePlayerController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "BasePlayerController.h"
#import "SimplePlayerController.h"


@interface BasePlayerController ()

@end

@implementation BasePlayerController

-(void)startMusicPlayerController{
    //简单播放器界面
    [SimplePlayerController start:self.navigationController];
    
    //黑胶唱片播放界面
//    [self startController:[MusicPlayerController class]];
}

@end
