//
//  TipUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/16.
//

#import <Foundation/Foundation.h>
#import "PlaceholderView.h"
#import "SuperToast.h"
NS_ASSUME_NONNULL_BEGIN

@interface TipUtil : NSObject
/// 显示错误提示
/// @param toast toast提示
/// @param placeholderView 占位控件
/// @param placeholderTitle 占位控件标题
+(void)showErrorWithToast:(NSString *)toast placeholderView:(nullable PlaceholderView *)placeholderView placeholderTitle:(NSString *)placeholderTitle;

/// <#Description#>
/// @param toast toast提示
/// @param placeholderView 占位控件
/// @param placeholderTitle 占位控件标题
/// @param placeholderIcon 占位控件图标
+(void)showErrorWithToast:(NSString *)toast placeholderView:(nullable PlaceholderView *)placeholderView placeholderTitle:(NSString *)placeholderTitle placeholderIcon:(nullable UIImage *)placeholderIcon;
@end

NS_ASSUME_NONNULL_END
