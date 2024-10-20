//
//  ButtonData.h
//  JQCloudMusic
//  发现界面，快捷按钮数据
//  Created by zhangjq on 2024/10/17.
//

#import "SuperBase.h"
#import "IconTitleButtonData.h"
NS_ASSUME_NONNULL_BEGIN

@interface ButtonData : SuperBase
/// 按钮列表
/// 类型为：IconTitleButtonData
@property (nonatomic, strong) NSMutableArray *datum;

/// 图标
@property(nonatomic, strong) UIImage *icon;

/// 标题
@property(nonatomic, strong) NSString *title;

@property(nonatomic, assign) ListStyle extra;

/// 根据图标，标题快速创建对象
+(instancetype)withIcon:(UIImage *)icon title:(NSString *)title extra:(ListStyle)extra;
@end

NS_ASSUME_NONNULL_END
