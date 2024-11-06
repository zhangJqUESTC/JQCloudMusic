//
//  LoginStatusChangedEvent.h
//  JQCloudMusic
//  登录状态改变的事件
//  Created by zhangjq on 2024/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginStatusChangedEvent : NSObject <QTEvent>
@property (nonatomic, assign) BOOL isLogin;
@end

NS_ASSUME_NONNULL_END
