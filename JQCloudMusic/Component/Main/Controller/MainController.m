//
//  MainController.m
//  JQCloudMusic
//  首页tabbar界面
//  Created by zhangjq on 2024/10/16.
//

//一行代码实现遮罩视图
#import <GKCover/GKCover.h>
#import "MainController.h"
#import "DiscoveryController.h"
#import "VideoController.h"
#import "MeController.h"
#import "FeedController.h"
#import "RoomController.h"
#import "ClickEvent.h"
#import "PlayListView.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    //选中高亮颜色
    self.tabBar.tintColor = [UIColor primaryColor];
    self.tabBar.translucent = YES;
    
    //去掉背景颜色
    if (@available(iOS 13, *)) {
       UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
       appearance.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
       appearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
        // 官方文档写的是 重置背景和阴影为透明
       [appearance configureWithTransparentBackground];
       self.tabBar.standardAppearance = appearance;
   } else {
       self.tabBar.backgroundImage = [UIImage new];
       self.tabBar.shadowImage = [UIImage new];
   }
    
    //添加子控制器
    [self addChildController:[DiscoveryController new] title:R.string.localizable.discovery imageName:@"Discovery"];
    [self addChildController:[VideoController new] title:R.string.localizable.video imageName:@"Video"];
    [self addChildController:[MeController new] title:R.string.localizable.me imageName:@"Me"];
    [self addChildController:[FeedController new] title:R.string.localizable.feed imageName:@"Feed"];
    [self addChildController:[RoomController new] title:R.string.localizable.live imageName:@"Live"];
    
    @weakify(self);
    //点击事件
    [QTSubMain(self,ClickEvent) next:^(ClickEvent *event) {
        @strongify(self);
        [self processClick:event.style];
    }];
    
}

-(void)processClick:(int)style{
    switch (style) {
        case StylePlayList:
            [self onListClick];
            break;
            
        default:
            break;
    }
}

-(void)onListClick{
    //创建一个View
    PlayListView *contentView = [PlayListView new];
    contentView.myWidth = SCREEN_WIDTH;
    contentView.myHeight = self.view.frame.size.height/1.5;

    //设置尺寸
//    contentView.gk_size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);

    [GKCover coverFrom:self.view contentView:contentView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:NO];
}



#pragma mark - TabBar

/// 添加子控制器
/// @param target target description
/// @param title title description
/// @param imageName imageName description
- (void)addChildController:(UIViewController *)target title:(NSString *)title imageName:(NSString *)imageName{
    
    //标题
    target.tabBarItem.title = title;
    
    //默认图片
    target.tabBarItem.image = [UIImage imageNamed:imageName];
    
    //选择后图片
    target.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Selected", imageName]];
    
    //选择后文本颜色
    [target.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorOnSurface]} forState:UIControlStateSelected];
    
    target.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    [self addChildViewController:target];
}

/// 选择了，如果已经选择了，再次点击还会调用
/// @param tabBar tabBar description
/// @param item item description
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"MainController didSelectItem %@",item.title);
}
@end
