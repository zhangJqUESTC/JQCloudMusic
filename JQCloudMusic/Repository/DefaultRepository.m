//
//  DefaultRepository.m
//  JQCloudMusic
//  本项目默认仓库
//  主要是从网络，数据库获取数据
//  目前项目中大部分操作都在这里
//  如果项目每个模块之间有明显的区别，例如：有商城，有歌单，那可以放到对应模块的Repository
//  Created by zhangjq on 2024/10/16.
//

#import "DefaultRepository.h"
#import "Video.h"

@implementation DefaultRepository
+(instancetype)shared{
    static DefaultRepository *instance = nil ;//1.声明一个空的静态的单例对象
    static dispatch_once_t onceToken; //2.声明一个静态的gcd的单次任务
    dispatch_once(&onceToken, ^{ //3.执行gcd单次任务：对对象进行初始化
        if (instance == nil) {
            instance = [[DefaultRepository alloc] init];
        }
    });
  return instance;
}

#pragma mark - 视频
/// 视频列表
-(void)videos:(int)page success:(SuperHttpListSuccess)success{
    [SuperHttpUtil requestListObjectWith:[Video class] url:URL_VIDEO parameters:@{@"page":[NSNumber numberWithInt:page]} success:success];
}
/// 视频详情
-(void)videoDetail:(NSString *)id success:(SuperHttpSuccess)success{
    [SuperHttpUtil requestObjectWith:[Video class] url:URL_VIDEO id:id success:success];
}
@end
