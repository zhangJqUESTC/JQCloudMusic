//
//  InputUserIdentityController.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "BaseTitleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputUserIdentityController : BaseTitleController
@property(nonatomic, assign) ListStyle style;

#pragma mark - 启动界面

/// 手机号登录
/// @param controller controller description
+ (void)startWithPhoneLogin:(UINavigationController *)controller;

/// 找回密码
/// @param controller controller description
+ (void)startWithForgotPassword:(UINavigationController *)controller;

/// 启动界面
/// @param controller controller description
/// @param style style description
+ (void)start:(UINavigationController *)controller style:(ListStyle)style;
@end

NS_ASSUME_NONNULL_END
