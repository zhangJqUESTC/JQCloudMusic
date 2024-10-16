//
//  UIImage+SuperUI.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SuperUI)
/// 根据颜色创建图片
/// @param color color description
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 设置图片支持着色
-(UIImage *)withTintColor;
@end

NS_ASSUME_NONNULL_END
