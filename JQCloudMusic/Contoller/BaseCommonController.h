//
//  BaseCommonController.h
//  JQCloudMusic
//  通用控制器
//  Created by zhangjq on 2024/10/12.
//

#import "BaseController.h"
#import "UIViewController+SuperUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCommonController : BaseController
/// 设置背景颜色
/// /// @param color color description
-(void)setBackgroundColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
