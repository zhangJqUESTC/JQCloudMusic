//
//  SheetData.h
//  JQCloudMusic
//  发现界面，歌单外层容器数据
//  Created by zhangjq on 2024/10/17.
//

#import "SuperBase.h"
#import "Sheet.h"
NS_ASSUME_NONNULL_BEGIN

@interface SheetData : SuperBase
/// 列表
/// 类型为：Sheet
@property (nonatomic, strong) NSArray *datum;
@end

NS_ASSUME_NONNULL_END
