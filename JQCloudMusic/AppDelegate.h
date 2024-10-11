//
//  AppDelegate.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

