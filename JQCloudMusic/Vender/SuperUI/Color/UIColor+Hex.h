//
//  UIColor+Hex.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/12.
//  使用16进制颜色创造颜色

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hex;
@end

NS_ASSUME_NONNULL_END
