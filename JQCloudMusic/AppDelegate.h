//
//  AppDelegate.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/1.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

/// 获取单例对象
+(instancetype)shared;
/// 显示引导界面
-(void)toGuide;

-(void)toMain;
// 登录成功后需要执行的动作
-(void)onLogin:(Session *)data;

- (void)logout;
@end

