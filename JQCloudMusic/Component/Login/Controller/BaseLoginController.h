//
//  BaseLoginController.h
//  JQCloudMusic
//  登录控制器的父类
//  Created by zhangjq on 2024/11/5.
//

#import "BaseTitleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseLoginController : BaseTitleController
-(void)login:(User *)data;
@end

NS_ASSUME_NONNULL_END
