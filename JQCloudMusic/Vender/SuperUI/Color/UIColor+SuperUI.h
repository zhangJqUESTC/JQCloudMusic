//
//  UIColor+SuperUI.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SuperUI)

/// 快捷创建动态颜色
/// @param color 正常颜色
/// @param darkColor 深色颜色
+(UIColor *) withColor:(UIColor *)color darkColor:(UIColor *)darkColor;
@end

NS_ASSUME_NONNULL_END
