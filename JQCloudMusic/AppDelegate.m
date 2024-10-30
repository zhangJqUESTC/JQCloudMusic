//
//  AppDelegate.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
//

#import "AppDelegate.h"
#import "SplashController.h"
#import "GuideController.h"
#import "MainController.h"
#import "LogFormater.h"
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

@end
