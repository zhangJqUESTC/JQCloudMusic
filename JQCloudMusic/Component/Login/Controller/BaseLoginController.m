//
//  BaseLoginController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/5.
//

#import "BaseLoginController.h"
#import "AppDelegate.h"


@interface BaseLoginController ()

@end

@implementation BaseLoginController

-(void)login:(User *)data{
    //设备id，就是谁谁的iPhone 这样的名称
    [data setDevice:[UIDevice currentDevice].name];
    
    [[DefaultRepository shared] loginWithController:self data:data success:^(BaseResponse * _Nonnull baseResponse, id  _Nonnull result) {
        [self onLogin:result];
    }];
}

-(void)onLogin:(Session *)data{
    //保存登录信息
    [PreferenceUtil setSession:data.session];
    [PreferenceUtil setUserId:data.userId];
    [PreferenceUtil setChatSession:data.chatToken];

    [[AppDelegate shared] onLogin:data];

}

@end
