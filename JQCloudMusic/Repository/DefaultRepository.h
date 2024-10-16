//
//  DefaultRepository.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultRepository : NSObject
// 单例
+(instancetype)shared;

#pragma mark - 视频

/// 视频列表
-(void)videos:(int)page success:(SuperHttpListSuccess)success;

/// 视频详情
-(void)videoDetail:(NSString *)id success:(SuperHttpSuccess)success;

/// 视频详情，可以手动处理错误
-(void)videoDetail:(NSString *)id success:(SuperHttpSuccess)success failure:(_Nullable SuperHttpFail)failure;

#pragma mark - 广告

/// 广告列表
/// @param position 那个位置广告；0：首页banner，10：启动界面
-(void)adsWithPosition:(int)position controller:(nullable BaseLogicController *)controller success:(SuperHttpListSuccess)success;

/// 启动界面广告
-(void)splashAd:(SuperHttpListSuccess)success;

/// 首页banner界面广告
-(void)bannerAdWithController:(nullable BaseLogicController *)controller success:(SuperHttpListSuccess)success;
@end

NS_ASSUME_NONNULL_END
