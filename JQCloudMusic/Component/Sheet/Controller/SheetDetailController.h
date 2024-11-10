//
//  SheetDetailController.h
//  JQCloudMusic
//  歌单详情
//  Created by zhangjq on 2024/11/7.
//

#import "BaseTitleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SheetDetailController : BaseTitleController
/// 数据id
@property(nonatomic, strong) NSString *id;

//启动方法
+ (void)start:(UINavigationController *)controller id:(NSString *)id;
@end

NS_ASSUME_NONNULL_END
