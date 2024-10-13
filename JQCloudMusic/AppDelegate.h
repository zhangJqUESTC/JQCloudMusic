//
//  AppDelegate.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
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

@end

