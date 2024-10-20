//
//  ImageUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageUtil : NSObject
/// 显示图片
/// @param view view description
/// @param uri uri description
+ (void)show:(UIImageView *)view uri:(NSString *)uri;

/// 显示绝对路径图片
/// @param view view description
/// @param uri uri description
+(void)showFull:(UIImageView *)view uri:(NSString *)uri;

/// 显示头像
/// @param view view description
/// @param uri uri description
+(void)showAvatar:(UIImageView *)view uri:(NSString *)uri;
@end

NS_ASSUME_NONNULL_END
