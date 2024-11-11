//
//  SheetDetailController.h
//  JQCloudMusic
//  歌单详情
//  Created by zhangjq on 2024/11/7.
//

#import "BasePlayerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SheetDetailController : BasePlayerController
/// 数据id
@property(nonatomic, strong) NSString *id;

//启动方法
+ (void)start:(UINavigationController *)controller id:(NSString *)id;
@end

NS_ASSUME_NONNULL_END
