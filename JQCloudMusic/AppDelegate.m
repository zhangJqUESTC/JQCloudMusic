//
//  AppDelegate.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/1.
//

//腾讯开源的偏好存储框架
#import <MMKV/MMKV.h>

#import "AppDelegate.h"
#import "SplashController.h"
#import "GuideController.h"
#import "MainController.h"
#import "LogFormater.h"
#import "LoginStatusChangedEvent.h"
#import "LoginHomeController.h"
#import "MusicListManager.h"
#import "MusicPlayerManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

+(instancetype)shared{
    return UIApplication.sharedApplication.delegate;
}

/// 显示引导界面
-(void)toGuide{
    GuideController *controller = [GuideController new];
    [self setRootViewController:controller];
}
/// 显示主界面
-(void)toMain{
    MainController *controller = [MainController new];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self setRootViewController:navigationController];
}

-(void)setRootViewController:(UIViewController *)controller{
    self.window.rootViewController = controller;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initMMKV];
    
    // Override point for customization after application launch.
    //设置默认显示界面
    [self initLog];
    [self initNetwork];
    SplashController *controller = [SplashController new];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)initLog{
    //日志级别
    #ifdef DEBUG
        //调试状态下，日志打印到控制台
        DDOSLogger *ddosLogger=[DDOSLogger sharedInstance];
        [self setLogFormat:ddosLogger];
        [DDLog addLogger:ddosLogger];
    #endif

    //所有环境，日志打印的文件
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];

    //每一个文件保存24小时的日志；也就是一个文件保存一天的日志
    fileLogger.rollingFrequency = 60 * 60 * 24;

    //总共保存最近30天的日志
    fileLogger.logFileManager.maximumNumberOfLogFiles = 30;
    [self setLogFormat:fileLogger];

    //文件中只保存警告及以上等级日志
    [DDLog addLogger:fileLogger withLevel:DDLogLevelWarning];
    
//    LogVerboseTag(@"TAG",@"JQCloudMusic Verbose");
//    LogDebugTag(@"TAG",@"JQCloudMusic Debug");
//    LogInfoTag(@"TAG",@"JQCloudMusic Info");
//    LogWarnTag(@"TAG",@"JQCloudMusic Warn");
//    LogErrorTag(@"TAG",@"JQCloudMusic Error");
    
    //获取log文件夹路径
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    NSLog(@"app delegate log path:%@", logDirectory);

    //获取排序后的日志名称
    NSArray <NSString *>*logFilenames = [fileLogger.logFileManager sortedLogFileNames];
    DDLogDebug(@"app delegate log files:%lu", (unsigned long)[logFilenames count]);
}

/// 设置日志格式
/// @param logger logger description
- (void)setLogFormat:(DDAbstractLogger *)logger{
    //设置日志格式；可以根据版本设置不同的格式
    //例如：debug模式下，日志格式信息更丰富，可以有方法名，行号；这样更容易查找错误
    //release：格式更紧凑，只能有用的
    logger.logFormatter = [[LogFormater alloc] init];
}

/// 初始化网络框架
- (void)initNetwork{
  #ifdef DEBUG
      //开启日志打印 默认打开(Debug级别)
      [MSNetwork openLog];
  #endif
  
  //最终完整Url为[NSString stringWithFormat:@“%@%@”,_baseURL,URL]，
  [MSNetwork setBaseURL:ENDPOINT];
  
  //设置全局请求参数
  //NSDictionary *dic = @{@"accountToken":@{@"clientType":@"",@"tokenKey":@""}};
  //[MSNetwork setBaseParameters:dic];
  
  //设置网络请求超时时间
  [MSNetwork setRequestTimeoutInterval:10.0f];
  
  //设置网络请求头
  //可一次设置多个也可单独设置
  //[MSNetwork setHeadr:@{@"api-version":@"v1.0.0"}];
  //[MSNetwork setValue:@"9" forHTTPHeaderField:@"fromType"];
  
  //请求数据为json
  [MSNetwork setRequestSerializer:MSRequestSerializerJSON];
}

-(void)onLogin:(Session *)data{
    //关闭登陆相关界面
    UINavigationController *navigationController=self.window.rootViewController;
    NSArray *vcs = navigationController.viewControllers;

    NSMutableArray *newVCS = [NSMutableArray array];

    for (int i=0; i < [vcs count]; i++) {
        UIViewController *it = [vcs objectAtIndex:i];
        if ([it isKindOfClass:[LoginHomeController class]]) {
            break;
        }
        [newVCS addObject:[vcs objectAtIndex:i]];
    }

    [navigationController setViewControllers:newVCS animated:YES];
    [self loginStatusChanged];
}

-(void)initMMKV{
    [MMKV initializeMMKV:nil];
}


//-(void)onLogin:(Session *)data{
//    [self loginStatusChanged];
//}

-(void)loginStatusChanged{
    LoginStatusChangedEvent *event = [[LoginStatusChangedEvent alloc] init];
    [QTEventBus.shared dispatch:event];
}

- (void)logout{
    [self logoutSilence];
}

/// 静默退出
- (void)logoutSilence{
    //清除登录相关信息
    [PreferenceUtil logout];
    
    //退出聊天服务器
//    [[RCIMClient sharedRCIMClient] logout];
//    
//    [self otherLogout];
//    
//    [DownloadManager destroy];
    
    [self loginStatusChanged];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JQCloudMusic"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - 媒体会话
/**
 初始化音频会话控制
 
 就是插入耳机，打电话；可以通过系统播放控制中心控制等功能
 
 官网文档：https://developer.apple.com/documentation/avfoundation/avaudiosession?language=objc
 */
-(void)initMedia{
    //告诉系统，我们要接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    //设置响应者
    [self becomeFirstResponder];

}

#pragma mark - 远程控制媒体
//第一响应者
- (BOOL)canBecomeFirstResponder{
    return YES;
}

/// 接收远程音乐播放控制消息
/// 例如：点击耳机上的按钮，点击媒体控制中心按钮等
/// @param event event description
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    //判断是不是远程控制事件
    if (event.type == UIEventTypeRemoteControl) {
        if ([[MusicListManager shared] getData] == nil) {
            //当前播放列表中没有音乐
            return;
        }

        //判断事件类型
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:{
                //点击了播放按钮
                [[MusicListManager shared] resume];
                NSLog(@"AppDelegate play");
            }
                break;
            case UIEventSubtypeRemoteControlPause:{
                //点击了暂停
                [[MusicListManager shared] pause];
                NSLog(@"AppDelegate pause");
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:{
                //下一首
                //双击iPhone有线耳机上的控制按钮
                Song *song = [[MusicListManager shared] next];
                [[MusicListManager shared] play:song];
                NSLog(@"AppDelegate Next");
            }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:{
                //上一首
                //三击iPhone有线耳机上的控制按钮
                Song *song = [[MusicListManager shared] previous];
                [[MusicListManager shared] play:song];
                NSLog(@"AppDelegate Previous");
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                //播放或者暂停
                if ([[MusicPlayerManager shared] isPlaying]) {
                    [[MusicListManager shared] pause];
                } else {
                    [[MusicListManager shared] resume];
                }
            }
                break;
            default:
                break;
        }
    }
}

-(MusicListManager *)getMusicListManager{
    return [MusicListManager shared];
}

@end
