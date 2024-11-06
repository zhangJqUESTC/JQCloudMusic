//
//  InputCodeController.h
//  JQCloudMusic
//  输入验证码界面
//  可以是手机验证，也可以邮箱验证码
//  Created by zhangjq on 2024/11/6.
//

#import "BaseLoginController.h"
#import "InputCodePageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputCodeController : BaseLoginController

@property(nonatomic, strong) InputCodePageData *pageData;

+ (void)start:(UINavigationController *)controller data:(InputCodePageData *)data;
@end

NS_ASSUME_NONNULL_END
